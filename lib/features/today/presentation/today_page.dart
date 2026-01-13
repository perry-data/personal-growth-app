import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_growth_app/features/today/application/today_providers.dart';
import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';
import 'package:personal_growth_app/shared/time/date_utils.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = AppDateUtils.today;
    final logAsync = ref.watch(todayLogStreamProvider(today));

    return Scaffold(
      appBar: AppBar(
        title: Text('Today ($today)'),
      ),
      body: logAsync.when(
        data: (log) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _TodayForm(initialLog: log, date: today),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _TodayForm extends ConsumerStatefulWidget {
  final DayLogModel? initialLog;
  final String date;

  const _TodayForm({required this.initialLog, required this.date});

  @override
  ConsumerState<_TodayForm> createState() => _TodayFormState();
}

class _TodayFormState extends ConsumerState<_TodayForm> {
  late int? _mood;
  late int? _energy;
  late int? _stress;

  @override
  void initState() {
    super.initState();
    _mood = widget.initialLog?.moodScore;
    _energy = widget.initialLog?.energyScore;
    _stress = widget.initialLog?.stressScore;
  }

  @override
  void didUpdateWidget(covariant _TodayForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLog != widget.initialLog) {
      // Update state if DB changes (optional, but good for keeping sync if updated elsewhere)
      // However, for local edits, we might want to keep user input.
      // For M0, let's keep it simple: if DB updates, we update UI unless we want to handle conflicts.
      // Given the "reactive" requirement, we should reflect DB.
      _mood = widget.initialLog?.moodScore;
      _energy = widget.initialLog?.energyScore;
      _stress = widget.initialLog?.stressScore;
    }
  }

  void _save() {
    final newLog = (widget.initialLog ?? DayLogModel(date: widget.date)).copyWith(
      moodScore: _mood,
      energyScore: _energy,
      stressScore: _stress,
      updatedAt: DateTime.now(),
    );

    ref.read(saveTodayLogUseCaseProvider).execute(newLog);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved!'), duration: Duration(milliseconds: 500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScoreSection('Mood', _mood, (val) => setState(() => _mood = val)),
        const SizedBox(height: 24),
        _buildScoreSection('Energy', _energy, (val) => setState(() => _energy = val)),
        const SizedBox(height: 24),
        _buildScoreSection('Stress', _stress, (val) => setState(() => _stress = val)),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection(String title, int? value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final score = index + 1;
            final isSelected = value == score;
            return ChoiceChip(
              label: Text('$score'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onChanged(score);
              },
            );
          }),
        ),
      ],
    );
  }
}
