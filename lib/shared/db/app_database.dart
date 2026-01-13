import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class DayLog extends Table {
  TextColumn get date => text()(); // YYYY-MM-DD, PK
  IntColumn get moodScore => integer().nullable()(); // 1-5
  IntColumn get energyScore => integer().nullable()(); // 1-5
  IntColumn get stressScore => integer().nullable()(); // 1-5
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [DayLog])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'personal_growth_app');
  }
}
