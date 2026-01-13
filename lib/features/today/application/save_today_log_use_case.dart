import 'package:personal_growth_app/features/today/domain/models/day_log_model.dart';
import 'package:personal_growth_app/features/today/domain/repos/today_repository.dart';

class SaveTodayLogUseCase {
  final TodayRepository _repo;

  SaveTodayLogUseCase(this._repo);

  Future<void> execute(DayLogModel log) async {
    await _repo.saveDayLog(log);
  }
}
