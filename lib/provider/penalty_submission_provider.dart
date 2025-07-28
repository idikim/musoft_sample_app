import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/model/penalty_category.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';
import 'package:madezone_study_student_app/provider/penalty_provider.dart';
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

final penaltySubmissionLogicProvider = Provider.autoDispose(
  (ref) => PenaltySubmissionLogic(ref),
);

class PenaltySubmissionLogic {
  final Ref ref;
  PenaltySubmissionLogic(this.ref);

  void resetSubmissionData() {
    ref.read(selectedReasonProvider.notifier).state = null;
    ref.read(selectedDateProvider.notifier).state = DateTime.now();
    ref.read(selectedStartTimeProvider.notifier).state = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0,
      0,
    );
    ref.read(selectedEndTimeProvider.notifier).state = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0,
      0,
    );
    ref.read(reasonInputProvider.notifier).state = '';
    ref.read(selectedImagePathsProvider.notifier).state = [];
  }

  Future<void> submitPenaltyReason({
    required Penalty? penalty,
    required Function onSuccess,
  }) async {
    final repository = ref.read(penaltyReasonRepositoryProvider);
    final selectedReason = ref.read(selectedReasonProvider);
    final selectedDate = ref.read(selectedDateProvider);
    final selectedStartTime = ref.read(selectedStartTimeProvider);
    final selectedEndTime = ref.read(selectedEndTimeProvider);
    final reasonInput = ref.read(reasonInputProvider);
    final selectedImagePaths = ref.read(selectedImagePathsProvider);
    final now = DateTime.now();

    final allReasons = await repository.getPenaltyReasons();
    int newId = 1;
    if (allReasons.isNotEmpty) {
      final maxId = allReasons
          .map((e) => int.tryParse(e.id) ?? 0)
          .reduce((a, b) => a > b ? a : b);
      newId = maxId + 1;
    }

    final penaltyReason = PenaltyReason(
      id: newId.toString(),
      category: selectedReason!,
      penaltyId: penalty?.id ?? '',
      startDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedStartTime.hour,
        selectedStartTime.minute,
      ),
      endDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedEndTime.hour,
        selectedEndTime.minute,
      ),
      imageUrls: selectedImagePaths.isNotEmpty ? selectedImagePaths : null,
      submittedAt: now,
      userReason: reasonInput,
    );

    await repository.savePenaltyReason(penaltyReason);

    ref.read(penaltyReasonsRefreshTrigger.notifier).state++;
    ref.read(penaltyReasonsProvider.notifier).refreshPenaltyReasons();

    if (penalty != null) {
      log(
        'PenaltySubmissionLogic: Original penalty ID for update: ${penalty.id}',
      );
      final updatedPenalty = Penalty(
        id: penalty.id,
        title: penalty.title,
        description: penalty.description,
        status: '승인대기',
        points: penalty.points,
        category: penalty.category,
        createdAt: penalty.createdAt,
        isReasonSubmitted: true,
        approvalDateTime: penalty.approvalDateTime,
      );
      await ref.read(penaltiesProvider.notifier).updatePenalty(updatedPenalty);
    }
    onSuccess();
  }
}
