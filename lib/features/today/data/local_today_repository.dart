import 'package:drift/drift.dart';
import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';
import 'package:personal_growth_app/features/today/domain/repos/today_repository.dart';
import 'package:personal_growth_app/shared/db/app_database.dart';

class LocalTodayRepository implements TodayRepository {
  final AppDatabase _db;

  LocalTodayRepository(this._db);

  DayLogModel _toModel(DayLogData entity) {
    return DayLogModel(
      date: entity.date,
      moodScore: entity.moodScore,
      energyScore: entity.energyScore,
      stressScore: entity.stressScore,
      note: entity.note,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<DayLogModel?> getDayLog(String date) async {
    final entity = await (_db.select(_db.dayLog)
          ..where((t) => t.date.equals(date)))
        .getSingleOrNull();
    return entity != null ? _toModel(entity) : null;
  }

  @override
  Future<void> saveDayLog(DayLogModel log) async {
    final companion = DayLogCompanion(
      date: Value(log.date),
      moodScore: Value(log.moodScore),
      energyScore: Value(log.energyScore),
      stressScore: Value(log.stressScore),
      note: Value(log.note),
      updatedAt: Value(DateTime.now()),
    );

    await _db.into(_db.dayLog).insertOnConflictUpdate(companion);
  }

  @override
  Stream<DayLogModel?> watchDayLog(String date) {
    return (_db.select(_db.dayLog)..where((t) => t.date.equals(date)))
        .watchSingleOrNull()
        .map((entity) => entity != null ? _toModel(entity) : null);
  }
}
