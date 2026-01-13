// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DayLogTable extends DayLog with TableInfo<$DayLogTable, DayLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
    'mood_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyScoreMeta = const VerificationMeta(
    'energyScore',
  );
  @override
  late final GeneratedColumn<int> energyScore = GeneratedColumn<int>(
    'energy_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressScoreMeta = const VerificationMeta(
    'stressScore',
  );
  @override
  late final GeneratedColumn<int> stressScore = GeneratedColumn<int>(
    'stress_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    moodScore,
    energyScore,
    stressScore,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    }
    if (data.containsKey('energy_score')) {
      context.handle(
        _energyScoreMeta,
        energyScore.isAcceptableOrUnknown(
          data['energy_score']!,
          _energyScoreMeta,
        ),
      );
    }
    if (data.containsKey('stress_score')) {
      context.handle(
        _stressScoreMeta,
        stressScore.isAcceptableOrUnknown(
          data['stress_score']!,
          _stressScoreMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DayLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayLogData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_score'],
      ),
      energyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_score'],
      ),
      stressScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_score'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $DayLogTable createAlias(String alias) {
    return $DayLogTable(attachedDatabase, alias);
  }
}

class DayLogData extends DataClass implements Insertable<DayLogData> {
  final String date;
  final int? moodScore;
  final int? energyScore;
  final int? stressScore;
  final String? note;
  final DateTime? updatedAt;
  const DayLogData({
    required this.date,
    this.moodScore,
    this.energyScore,
    this.stressScore,
    this.note,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || moodScore != null) {
      map['mood_score'] = Variable<int>(moodScore);
    }
    if (!nullToAbsent || energyScore != null) {
      map['energy_score'] = Variable<int>(energyScore);
    }
    if (!nullToAbsent || stressScore != null) {
      map['stress_score'] = Variable<int>(stressScore);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DayLogCompanion toCompanion(bool nullToAbsent) {
    return DayLogCompanion(
      date: Value(date),
      moodScore: moodScore == null && nullToAbsent
          ? const Value.absent()
          : Value(moodScore),
      energyScore: energyScore == null && nullToAbsent
          ? const Value.absent()
          : Value(energyScore),
      stressScore: stressScore == null && nullToAbsent
          ? const Value.absent()
          : Value(stressScore),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DayLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayLogData(
      date: serializer.fromJson<String>(json['date']),
      moodScore: serializer.fromJson<int?>(json['moodScore']),
      energyScore: serializer.fromJson<int?>(json['energyScore']),
      stressScore: serializer.fromJson<int?>(json['stressScore']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'moodScore': serializer.toJson<int?>(moodScore),
      'energyScore': serializer.toJson<int?>(energyScore),
      'stressScore': serializer.toJson<int?>(stressScore),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DayLogData copyWith({
    String? date,
    Value<int?> moodScore = const Value.absent(),
    Value<int?> energyScore = const Value.absent(),
    Value<int?> stressScore = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => DayLogData(
    date: date ?? this.date,
    moodScore: moodScore.present ? moodScore.value : this.moodScore,
    energyScore: energyScore.present ? energyScore.value : this.energyScore,
    stressScore: stressScore.present ? stressScore.value : this.stressScore,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  DayLogData copyWithCompanion(DayLogCompanion data) {
    return DayLogData(
      date: data.date.present ? data.date.value : this.date,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      energyScore: data.energyScore.present
          ? data.energyScore.value
          : this.energyScore,
      stressScore: data.stressScore.present
          ? data.stressScore.value
          : this.stressScore,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayLogData(')
          ..write('date: $date, ')
          ..write('moodScore: $moodScore, ')
          ..write('energyScore: $energyScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, moodScore, energyScore, stressScore, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayLogData &&
          other.date == this.date &&
          other.moodScore == this.moodScore &&
          other.energyScore == this.energyScore &&
          other.stressScore == this.stressScore &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class DayLogCompanion extends UpdateCompanion<DayLogData> {
  final Value<String> date;
  final Value<int?> moodScore;
  final Value<int?> energyScore;
  final Value<int?> stressScore;
  final Value<String?> note;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const DayLogCompanion({
    this.date = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.energyScore = const Value.absent(),
    this.stressScore = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayLogCompanion.insert({
    required String date,
    this.moodScore = const Value.absent(),
    this.energyScore = const Value.absent(),
    this.stressScore = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DayLogData> custom({
    Expression<String>? date,
    Expression<int>? moodScore,
    Expression<int>? energyScore,
    Expression<int>? stressScore,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (moodScore != null) 'mood_score': moodScore,
      if (energyScore != null) 'energy_score': energyScore,
      if (stressScore != null) 'stress_score': stressScore,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayLogCompanion copyWith({
    Value<String>? date,
    Value<int?>? moodScore,
    Value<int?>? energyScore,
    Value<int?>? stressScore,
    Value<String?>? note,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return DayLogCompanion(
      date: date ?? this.date,
      moodScore: moodScore ?? this.moodScore,
      energyScore: energyScore ?? this.energyScore,
      stressScore: stressScore ?? this.stressScore,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (energyScore.present) {
      map['energy_score'] = Variable<int>(energyScore.value);
    }
    if (stressScore.present) {
      map['stress_score'] = Variable<int>(stressScore.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayLogCompanion(')
          ..write('date: $date, ')
          ..write('moodScore: $moodScore, ')
          ..write('energyScore: $energyScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DayLogTable dayLog = $DayLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dayLog];
}

typedef $$DayLogTableCreateCompanionBuilder =
    DayLogCompanion Function({
      required String date,
      Value<int?> moodScore,
      Value<int?> energyScore,
      Value<int?> stressScore,
      Value<String?> note,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$DayLogTableUpdateCompanionBuilder =
    DayLogCompanion Function({
      Value<String> date,
      Value<int?> moodScore,
      Value<int?> energyScore,
      Value<int?> stressScore,
      Value<String?> note,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$DayLogTableFilterComposer
    extends Composer<_$AppDatabase, $DayLogTable> {
  $$DayLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressScore => $composableBuilder(
    column: $table.stressScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayLogTableOrderingComposer
    extends Composer<_$AppDatabase, $DayLogTable> {
  $$DayLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressScore => $composableBuilder(
    column: $table.stressScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayLogTable> {
  $$DayLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressScore => $composableBuilder(
    column: $table.stressScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DayLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayLogTable,
          DayLogData,
          $$DayLogTableFilterComposer,
          $$DayLogTableOrderingComposer,
          $$DayLogTableAnnotationComposer,
          $$DayLogTableCreateCompanionBuilder,
          $$DayLogTableUpdateCompanionBuilder,
          (DayLogData, BaseReferences<_$AppDatabase, $DayLogTable, DayLogData>),
          DayLogData,
          PrefetchHooks Function()
        > {
  $$DayLogTableTableManager(_$AppDatabase db, $DayLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int?> moodScore = const Value.absent(),
                Value<int?> energyScore = const Value.absent(),
                Value<int?> stressScore = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogCompanion(
                date: date,
                moodScore: moodScore,
                energyScore: energyScore,
                stressScore: stressScore,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int?> moodScore = const Value.absent(),
                Value<int?> energyScore = const Value.absent(),
                Value<int?> stressScore = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogCompanion.insert(
                date: date,
                moodScore: moodScore,
                energyScore: energyScore,
                stressScore: stressScore,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayLogTable,
      DayLogData,
      $$DayLogTableFilterComposer,
      $$DayLogTableOrderingComposer,
      $$DayLogTableAnnotationComposer,
      $$DayLogTableCreateCompanionBuilder,
      $$DayLogTableUpdateCompanionBuilder,
      (DayLogData, BaseReferences<_$AppDatabase, $DayLogTable, DayLogData>),
      DayLogData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DayLogTableTableManager get dayLog =>
      $$DayLogTableTableManager(_db, _db.dayLog);
}
