import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';
import 'package:madezone_study_student_app/repository/daily_schedule_repository.dart';

final allDailySchedulesProvider =
    StateNotifierProvider<AllDailyScheduleNotifier, List<DailySchedule>>(
      (ref) => AllDailyScheduleNotifier(),
    );

class AllDailyScheduleNotifier extends StateNotifier<List<DailySchedule>> {
  AllDailyScheduleNotifier() : super([]) {
    loadAllDailySchedules();
  }

  Future<void> loadAllDailySchedules() async {
    state = await DailyScheduleRepository.loadDailySchedules();
  }

  Future<void> addSchedule(DailySchedule schedule) async {
    await DailyScheduleRepository.addDailySchedule(schedule);
    await loadAllDailySchedules();
  }

  Future<void> clearAllDailySchedules() async {
    await DailyScheduleRepository.clearDailySchedules();
    await loadAllDailySchedules();
  }
}

final dailyScheduleForDateProvider = StateNotifierProvider.family<
  DailyScheduleNotifier,
  List<DailySchedule>,
  DateTime
>((ref, date) => DailyScheduleNotifier(ref, date));

class DailyScheduleNotifier extends StateNotifier<List<DailySchedule>> {
  final DateTime selectedDate;
  final Ref _ref;

  DailyScheduleNotifier(this._ref, this.selectedDate) : super([]) {
    _ref.listen<List<DailySchedule>>(allDailySchedulesProvider, (
      _,
      allSchedules,
    ) {
      _filterAndSetState(allSchedules);
    }, fireImmediately: true);
  }

  void _filterAndSetState(List<DailySchedule> allSchedules) {
    state =
        allSchedules
            .where(
              (s) =>
                  s.date.year == selectedDate.year &&
                  s.date.month == selectedDate.month &&
                  s.date.day == selectedDate.day,
            )
            .toList()
          ..sort((a, b) {
            final timeA = a.startHour * 60 + a.startMinute;
            final timeB = b.startHour * 60 + b.startMinute;
            return timeA.compareTo(timeB);
          });
  }
}
