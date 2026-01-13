import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';

abstract class TodayRepository {
  Future<void> saveDayLog(DayLogModel log);
  Stream<DayLogModel?> watchDayLog(String date);
  Future<DayLogModel?> getDayLog(String date);
}
