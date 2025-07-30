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

  Future<void> addSampleSchedules() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));

    final sampleSchedules = [
      DailySchedule(
        title: '수학 공부',
        date: startOfWeek.add(Duration(days: 1)),
        startHour: 9,
        startMinute: 0,
        endHour: 11,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['수학 문제 풀이', '개념 정리'],
      ),
      DailySchedule(
        title: '영어 공부',
        date: startOfWeek.add(Duration(days: 1)),
        startHour: 14,
        startMinute: 0,
        endHour: 16,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['영어 단어 암기', '문법 공부'],
      ),
      DailySchedule(
        title: '지각 벌점',
        date: startOfWeek.add(Duration(days: 1)),
        startHour: 8,
        startMinute: 0,
        endHour: 9,
        endMinute: 0,
        category: ScheduleCategory.penalty,
        details: ['지각으로 인한 벌점'],
      ),
      DailySchedule(
        title: '국어 공부',
        date: startOfWeek.add(Duration(days: 2)),
        startHour: 10,
        startMinute: 0,
        endHour: 12,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['독서', '문학 작품 분석'],
      ),
      DailySchedule(
        title: '과학 공부',
        date: startOfWeek.add(Duration(days: 2)),
        startHour: 15,
        startMinute: 0,
        endHour: 17,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['실험 준비', '개념 정리'],
      ),
      DailySchedule(
        title: '복장 불량 벌점',
        date: startOfWeek.add(Duration(days: 2)),
        startHour: 7,
        startMinute: 30,
        endHour: 8,
        endMinute: 30,
        category: ScheduleCategory.penalty,
        details: ['복장 불량으로 인한 벌점'],
      ),
      DailySchedule(
        title: '수학 문제 풀이',
        date: startOfWeek.add(Duration(days: 3)),
        startHour: 9,
        startMinute: 0,
        endHour: 12,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['고난도 문제', '실전 연습'],
      ),
      DailySchedule(
        title: '영어 회화',
        date: startOfWeek.add(Duration(days: 4)),
        startHour: 13,
        startMinute: 0,
        endHour: 15,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['회화 연습', '발음 교정'],
      ),
      DailySchedule(
        title: '사회 공부',
        date: startOfWeek.add(Duration(days: 5)),
        startHour: 10,
        startMinute: 0,
        endHour: 11,
        endMinute: 30,
        category: ScheduleCategory.study,
        details: ['역사', '지리'],
      ),
      DailySchedule(
        title: '휴대폰 사용 벌점',
        date: startOfWeek.add(Duration(days: 5)),
        startHour: 12,
        startMinute: 0,
        endHour: 13,
        endMinute: 0,
        category: ScheduleCategory.penalty,
        details: ['수업 중 휴대폰 사용'],
      ),
      DailySchedule(
        title: '종합 복습',
        date: startOfWeek.add(Duration(days: 6)),
        startHour: 14,
        startMinute: 0,
        endHour: 17,
        endMinute: 0,
        category: ScheduleCategory.study,
        details: ['전체 과목 복습', '약점 보완'],
      ),
      DailySchedule(
        title: '기물 파손 벌점',
        date: startOfWeek.add(Duration(days: 6)),
        startHour: 16,
        startMinute: 0,
        endHour: 17,
        endMinute: 0,
        category: ScheduleCategory.penalty,
        details: ['기물 파손으로 인한 벌점'],
      ),
    ];

    for (final schedule in sampleSchedules) {
      await DailyScheduleRepository.addDailySchedule(schedule);
    }
    await loadAllDailySchedules();
  }
}

final dailyScheduleForDateProvider = StateNotifierProvider.family<
  DailyScheduleNotifier,
  List<DailySchedule>,
  DateTime
>((ref, date) => DailyScheduleNotifier(ref, date));

final totalStudyMinutesForDateProvider = Provider.family<int, DateTime>((
  ref,
  date,
) {
  final allSchedules = ref.watch(allDailySchedulesProvider);
  final dailySchedules = allSchedules.where(
    (s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day,
  );

  int totalMinutes = 0;
  for (var schedule in dailySchedules) {
    if (schedule.category == ScheduleCategory.study) {
      final startTotalMinutes = schedule.startHour * 60 + schedule.startMinute;
      final endTotalMinutes = schedule.endHour * 60 + schedule.endMinute;
      totalMinutes += (endTotalMinutes - startTotalMinutes);
    }
  }
  return totalMinutes;
});

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
