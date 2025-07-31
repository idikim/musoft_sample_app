import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/study_time.dart';
import 'package:madezone_study_student_app/repository/study_time_repository.dart';
import 'package:madezone_study_student_app/provider/daily_schedule_provider.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';

final studyTimeProvider =
    StateNotifierProvider<StudyTimeNotifier, List<StudyTime>>(
      (ref) => StudyTimeNotifier(),
    );

class StudyTimeNotifier extends StateNotifier<List<StudyTime>> {
  StudyTimeNotifier() : super([]) {
    loadStudyTimes();
  }

  Future<void> loadStudyTimes() async {
    state = await StudyTimeRepository.loadStudyTimes();
  }

  Future<void> clearStudyTimes() async {
    await StudyTimeRepository.clearStudyTimes();
    await loadStudyTimes();
  }
}

final weeklyStudyTimeProvider = Provider<int>((ref) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday));

  int totalMinutes = 0;

  for (int i = 0; i < 7; i++) {
    final date = startOfWeek.add(Duration(days: i));
    final schedules = ref.watch(dailyScheduleForDateProvider(date));

    for (final schedule in schedules) {
      if (schedule.category == ScheduleCategory.study) {
        final startMinutes = schedule.startHour * 60 + schedule.startMinute;
        final endMinutes = schedule.endHour * 60 + schedule.endMinute;
        final duration = endMinutes - startMinutes;
        totalMinutes += duration;
      }
    }
  }

  return totalMinutes;
});

final averageDailyStudyTimeProvider = Provider<int>((ref) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday));

  int totalMinutes = 0;
  int daysWithStudy = 0;

  for (int i = 0; i < 7; i++) {
    final date = startOfWeek.add(Duration(days: i));
    final schedules = ref.watch(dailyScheduleForDateProvider(date));

    int dailyStudyMinutes = 0;
    for (final schedule in schedules) {
      if (schedule.category == ScheduleCategory.study) {
        final startMinutes = schedule.startHour * 60 + schedule.startMinute;
        final endMinutes = schedule.endHour * 60 + schedule.endMinute;
        final duration = endMinutes - startMinutes;
        dailyStudyMinutes += duration;
      }
    }

    if (dailyStudyMinutes > 0) {
      totalMinutes += dailyStudyMinutes;
      daysWithStudy++;
    }
  }

  if (daysWithStudy == 0) {
    return 0;
  }

  return (totalMinutes / daysWithStudy).round();
});

final subjectStudyTimeProvider = Provider<Map<String, int>>((ref) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday));

  Map<String, int> subjectMinutes = {
    '국어': 0,
    '수학': 0,
    '영어': 0,
    '과학': 0,
    '사회': 0,
    '기타': 0,
  };

  for (int i = 0; i < 7; i++) {
    final date = startOfWeek.add(Duration(days: i));
    final schedules = ref.watch(dailyScheduleForDateProvider(date));

    for (final schedule in schedules) {
      if (schedule.category == ScheduleCategory.study) {
        final startMinutes = schedule.startHour * 60 + schedule.startMinute;
        final endMinutes = schedule.endHour * 60 + schedule.endMinute;
        final duration = endMinutes - startMinutes;

        String subject = '기타';
        final title = schedule.title.toLowerCase();

        if (title.contains('국어') ||
            title.contains('독서') ||
            title.contains('문학')) {
          subject = '국어';
        } else if (title.contains('수학')) {
          subject = '수학';
        } else if (title.contains('영어') || title.contains('회화')) {
          subject = '영어';
        } else if (title.contains('과학') || title.contains('실험')) {
          subject = '과학';
        } else if (title.contains('사회') ||
            title.contains('역사') ||
            title.contains('지리')) {
          subject = '사회';
        }

        subjectMinutes[subject] = (subjectMinutes[subject] ?? 0) + duration;
      }
    }
  }

  subjectMinutes.removeWhere((key, value) => value == 0);

  return subjectMinutes;
});

final weeklyStudySubjectCountProvider = Provider<int>((ref) {
  final subjectStudyTimes = ref.watch(subjectStudyTimeProvider);
  return subjectStudyTimes.keys.where((subject) => subject != '기타').length;
});

final mostStudiedSubjectProvider = Provider<String>((ref) {
  final subjectStudyTimes = ref.watch(subjectStudyTimeProvider);

  if (subjectStudyTimes.isEmpty) {
    return '없음';
  }

  String mostStudiedSubject = '없음';
  int maxMinutes = 0;

  subjectStudyTimes.forEach((subject, minutes) {
    if (subject != '기타' && minutes > maxMinutes) {
      maxMinutes = minutes;
      mostStudiedSubject = subject;
    }
  });

  return mostStudiedSubject;
});
