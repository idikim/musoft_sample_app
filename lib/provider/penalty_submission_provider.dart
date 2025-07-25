import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty_category.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';
import 'package:madezone_study_student_app/repository/penalty_reason_repository.dart';

final isAbsenceSelectedProvider = StateProvider<bool>((ref) => false);

final selectedReasonProvider = StateProvider<PenaltyCategory?>((ref) => null);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedStartTimeProvider = StateProvider<DateTime>(
  (ref) => DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
  ),
);
final selectedEndTimeProvider = StateProvider<DateTime>(
  (ref) => DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
  ),
);
final reasonInputProvider = StateProvider<String>((ref) => '');
final selectedImagePathsProvider = StateProvider<List<String>>((ref) => []);

final penaltyReasonsRefreshTrigger = StateProvider<int>((ref) => 0);

final penaltyReasonRepositoryProvider = Provider(
  (ref) => PenaltyReasonRepository(),
);

final penaltyReasonsProvider = FutureProvider<List<PenaltyReason>>((ref) async {
  ref.watch(penaltyReasonsRefreshTrigger);
  final repository = ref.read(penaltyReasonRepositoryProvider);
  return repository.getPenaltyReasons();
});
