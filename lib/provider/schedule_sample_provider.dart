import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';
import 'package:madezone_study_student_app/repository/schedule_sample_repository.dart';
import 'package:madezone_study_student_app/view/learning_page/my_schedule/schedule_sample_data.dart';

// New provider for all daily schedules
final allDailySchedulesProvider = StateNotifierProvider<AllDailyScheduleNotifier, List<DailySchedule>>(
  (ref) => AllDailyScheduleNotifier(),
);

class AllDailyScheduleNotifier extends StateNotifier<List<DailySchedule>> {
  AllDailyScheduleNotifier() : super([]) {
    loadAllDailySchedules();
  }

  Future<void> loadAllDailySchedules() async {
    state = await DailyScheduleRepository.loadDailySchedules();
  }

  Future<void> addAllSampleDailySchedules() async {
    await DailyScheduleRepository.clearDailySchedules(); // Clear existing data
    await DailyScheduleRepository.addSampleDailySchedules(sampleDailySchedules);
    await loadAllDailySchedules();
  }

  Future<void> clearAllDailySchedules() async {
    await DailyScheduleRepository.clearDailySchedules();
    await loadAllDailySchedules();
  }
}

// Existing family provider, now depending on allDailySchedulesProvider
final dailyScheduleForDateProvider = StateNotifierProvider.family<DailyScheduleNotifier, List<DailySchedule>, DateTime>(
  (ref, date) => DailyScheduleNotifier(ref, date), // Pass ref to access other providers
);

class DailyScheduleNotifier extends StateNotifier<List<DailySchedule>> {
  final DateTime selectedDate;
  final Ref _ref; // Store ref to access other providers

  DailyScheduleNotifier(this._ref, this.selectedDate) : super([]) {
    _ref.listen<List<DailySchedule>>(allDailySchedulesProvider, (_, allSchedules) {
      _filterAndSetState(allSchedules);
    }, fireImmediately: true); // Listen for changes in allDailySchedulesProvider
  }

  void _filterAndSetState(List<DailySchedule> allSchedules) {
    state = allSchedules.where((s) =>
        s.date.year == selectedDate.year &&
        s.date.month == selectedDate.month &&
        s.date.day == selectedDate.day).toList();
  }
}