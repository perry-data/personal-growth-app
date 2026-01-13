import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_growth_app/features/today/application/save_today_log_use_case.dart';
import 'package:personal_growth_app/features/today/data/local_today_repository.dart';
import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';
import 'package:personal_growth_app/features/today/domain/repos/today_repository.dart';
import 'package:personal_growth_app/shared/db/app_database.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository Provider
final todayRepositoryProvider = Provider<TodayRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalTodayRepository(db);
});

// UseCase Provider
final saveTodayLogUseCaseProvider = Provider<SaveTodayLogUseCase>((ref) {
  final repo = ref.watch(todayRepositoryProvider);
  return SaveTodayLogUseCase(repo);
});

// Stream Provider for UI
final todayLogStreamProvider = StreamProvider.family<DayLogModel?, String>((ref, date) {
  final repo = ref.watch(todayRepositoryProvider);
  return repo.watchDayLog(date);
});
