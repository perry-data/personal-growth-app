class DayLogModel {
  final String date;
  final int? moodScore;
  final int? energyScore;
  final int? stressScore;
  final String? note;
  final DateTime? updatedAt;

  const DayLogModel({
    required this.date,
    this.moodScore,
    this.energyScore,
    this.stressScore,
    this.note,
    this.updatedAt,
  });

  DayLogModel copyWith({
    String? date,
    int? moodScore,
    int? energyScore,
    int? stressScore,
    String? note,
    DateTime? updatedAt,
  }) {
    return DayLogModel(
      date: date ?? this.date,
      moodScore: moodScore ?? this.moodScore,
      energyScore: energyScore ?? this.energyScore,
      stressScore: stressScore ?? this.stressScore,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
