import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/study_time.dart';
import 'package:madezone_study_student_app/repository/study_time_repository.dart';

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
  final allStudyTimes = ref.watch(studyTimeProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
  final endOfWeek = startOfWeek.add(Duration(days: 7));

  return allStudyTimes
      .where((studyTime) {
        return studyTime.date.isAfter(
              startOfWeek.subtract(Duration(days: 1)),
            ) &&
            studyTime.date.isBefore(endOfWeek);
      })
      .fold(0, (total, studyTime) => total + studyTime.minutes);
});

final averageDailyStudyTimeProvider = Provider<int>((ref) {
  final weeklyTotalMinutes = ref.watch(weeklyStudyTimeProvider);
  return (weeklyTotalMinutes / 7).round();
});

final subjectStudyTimeProvider = Provider<Map<String, int>>((ref) {
  return {'국어': 5 * 60, '수학': 8 * 60, '영어': 6 * 60, '과학': 4 * 60, '사회': 2 * 60};
});
