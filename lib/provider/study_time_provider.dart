import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/study_time.dart';
import 'package:madezone_study_student_app/repository/study_time_repository.dart';
import 'package:madezone_study_student_app/view/learning_page/my_schedule/study_time_sample_data.dart';

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

  Future<void> addSampleStudyTimes() async {
    await StudyTimeRepository.addSampleStudyTimes(sampleStudyTimes);
    await loadStudyTimes();
  }

  Future<void> clearStudyTimes() async {
    await StudyTimeRepository.clearStudyTimes();
    await loadStudyTimes();
  }
}
