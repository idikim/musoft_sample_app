import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/schedule_sample.dart';
import 'package:madezone_study_student_app/repository/schedule_sample_repository.dart';
import 'package:madezone_study_student_app/view/learning_page/my_schedule/schedule_sample_data.dart';

final scheduleSampleProvider =
    StateNotifierProvider<ScheduleSampleNotifier, List<ScheduleSample>>(
      (ref) => ScheduleSampleNotifier(),
    );

class ScheduleSampleNotifier extends StateNotifier<List<ScheduleSample>> {
  ScheduleSampleNotifier() : super([]) {
    loadScheduleSamples();
  }

  Future<void> loadScheduleSamples() async {
    state = await ScheduleSampleRepository.loadScheduleSamples();
  }

  Future<void> addSampleScheduleSamples() async {
    await ScheduleSampleRepository.addSampleScheduleSamples(
      sampleScheduleSamples,
    );
    await loadScheduleSamples();
  }

  Future<void> clearScheduleSamples() async {
    await ScheduleSampleRepository.clearScheduleSamples();
    await loadScheduleSamples();
  }
}
