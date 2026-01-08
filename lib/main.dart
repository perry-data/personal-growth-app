import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const ProviderScope(child: App()));
}

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

String ymd(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d'; // Postgres date: YYYY-MM-DD
}

final todayEntryProvider = StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final user = supabase.auth.currentUser;
  if (user == null) return const Stream.empty();

  final today = ymd(DateTime.now());
  const slot = 'day';

  // stream() 会返回初始数据 + 后续数据库变化（需要为表开启 replication）
  // primaryKey 需要与你表的主键一致
  final stream = supabase
      .from('daily_entries')
      .stream(primaryKey: ['user_id', 'date', 'slot']);

  return stream.map((rows) {
    for (final row in rows) {
      if (row['user_id'] == user.id && row['date'] == today && row['slot'] == slot) {
        return row;
      }
    }
    return null;
  });
});

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth V1',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supabaseProvider);
    final session = supabase.auth.currentSession;

    if (session == null) return const LoginPage();
    return const HomePage();
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _signUp() async {
    final supabase = ref.read(supabaseProvider);
    setState(() => _loading = true);
    try {
      await supabase.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('注册成功：请直接登录（若你开启了邮箱验证，请先去邮箱点确认）')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('注册失败：${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signIn() async {
    final supabase = ref.read(supabaseProvider);
    setState(() => _loading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) setState(() {}); // 触发 AuthGate rebuild
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('登录失败：${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录 / 注册')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signIn,
                    child: Text(_loading ? '...' : '登录'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading ? null : _signUp,
                    child: const Text('注册'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _save(
    WidgetRef ref, {
    required int focus,
    required int execution,
    required int mood,
    required String note,
  }) async {
    final supabase = ref.read(supabaseProvider);
    final user = supabase.auth.currentUser!;
    final today = ymd(DateTime.now());

    // 用 upsert：同一天同 slot 反复保存，只更新同一行
    await supabase.from('daily_entries').upsert(
      {
        'user_id': user.id,
        'date': today,
        'slot': 'day',
        'focus': focus,
        'execution': execution,
        'mood': mood,
        'note': note,
      },
      onConflict: 'user_id,date,slot',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supabaseProvider);
    final asyncEntry = ref.watch(todayEntryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('今日'),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              // 退回登录页
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
            child: const Text('退出'),
          ),
        ],
      ),
      body: asyncEntry.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (row) {
          final focus = (row?['focus'] ?? 50) as int;
          final execution = (row?['execution'] ?? 50) as int;
          final mood = (row?['mood'] ?? 50) as int;
          final note = (row?['note'] ?? '') as String;

          final noteCtl = TextEditingController(text: note);

          Widget slider(String label, int value, Future<void> Function(int) onSaved) {
            double v = value.toDouble();
            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$label：${v.round()}'),
                    Slider(
                      min: 0,
                      max: 100,
                      divisions: 100,
                      value: v,
                      onChanged: (nv) => setState(() => v = nv),
                      onChangeEnd: (nv) async {
                        await onSaved(nv.round());
                        // 注意：真正的 UI 刷新依赖 stream 推回来的新值
                      },
                    ),
                  ],
                );
              },
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                slider('专注力', focus, (newFocus) => _save(
                      ref,
                      focus: newFocus,
                      execution: execution,
                      mood: mood,
                      note: noteCtl.text,
                    )),
                slider('执行力', execution, (newExec) => _save(
                      ref,
                      focus: focus,
                      execution: newExec,
                      mood: mood,
                      note: noteCtl.text,
                    )),
                slider('情绪', mood, (newMood) => _save(
                      ref,
                      focus: focus,
                      execution: execution,
                      mood: newMood,
                      note: noteCtl.text,
                    )),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: '备注',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await _save(
                      ref,
                      focus: focus,
                      execution: execution,
                      mood: mood,
                      note: noteCtl.text,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已保存')),
                      );
                    }
                  },
                  child: const Text('保存备注'),
                ),
                const SizedBox(height: 24),
                const Text('提示：把同账号在另一台电脑也打开，这里保存后对方会自动刷新（需开启 realtime）。'),
              ],
            ),
          );
        },
      ),
    );
  }
}
