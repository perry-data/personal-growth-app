import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_growth_app/app/app_shell.dart';
import 'package:personal_growth_app/features/today/application/today_providers.dart';
import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';
import 'package:personal_growth_app/features/today/domain/repos/today_repository.dart';

// Mock Repository
class MockTodayRepository implements TodayRepository {
  DayLogModel? _log;

  @override
  Future<DayLogModel?> getDayLog(String date) async => _log;

  @override
  Future<void> saveDayLog(DayLogModel log) async {
    _log = log;
  }

  @override
  Stream<DayLogModel?> watchDayLog(String date) {
    return Stream.value(_log);
  }
}

void main() {
  testWidgets('AppShell renders TodayPage by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayRepositoryProvider.overrideWithValue(MockTodayRepository()),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );

    expect(find.text('Today'), findsWidgets); // NavigationRail label and AppBar title
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('TodayPage renders score inputs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayRepositoryProvider.overrideWithValue(MockTodayRepository()),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    
    // Allow stream to emit
    await tester.pump();

    expect(find.text('Mood'), findsOneWidget);
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Stress'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
