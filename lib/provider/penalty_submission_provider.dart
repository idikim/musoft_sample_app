import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/penalty_provider.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/repository/penalty_reason_repository.dart';

/// 결석 여부 선택 상태
final isAbsenceSelectedProvider = StateProvider<bool>((ref) => false);

/// 선택된 벌점 사유 카테고리
final selectedReasonProvider = StateProvider<PenaltyCategory?>((ref) => null);

/// 직접 입력한 사유
final reasonInputProvider = StateProvider<String>((ref) => '');

/// 선택된 이미지 경로 리스트
final selectedImagePathsProvider = StateProvider<List<String>>((ref) => []);

/// 벌점 사유 새로고침 트리거
final penaltyReasonsRefreshTrigger = StateProvider<int>((ref) => 0);

/// PenaltyReasonRepository Provider
final penaltyReasonRepositoryProvider = Provider(
  (ref) => PenaltyReasonRepository(),
);

/// 벌점 사유 제출 로직 Provider (autoDispose)
final penaltySubmissionLogicProvider = Provider.autoDispose(
  (ref) => PenaltySubmissionLogic(ref),
);

/// 테스트용 Provider (의존성 주입을 위한)
final penaltySubmissionLogicTestProvider = Provider.autoDispose
    .family<PenaltySubmissionLogic, Ref>(
      (ref, testRef) => PenaltySubmissionLogic(testRef),
    );

/// 벌점 사유 제출 페이지 상태 관리
final submissionPageStateProvider =
    StateNotifierProvider<SubmissionPageStateNotifier, SubmissionPageState>(
      (ref) => SubmissionPageStateNotifier(),
    );

/// 벌점 사유 제출 페이지 상태
class SubmissionPageState {
  final int currentPageIndex;
  final bool isStep1Valid;
  final bool isStep2Valid;
  final bool isSubmitting;

  const SubmissionPageState({
    this.currentPageIndex = 0,
    this.isStep1Valid = false,
    this.isStep2Valid = false,
    this.isSubmitting = false,
  });

  SubmissionPageState copyWith({
    int? currentPageIndex,
    bool? isStep1Valid,
    bool? isStep2Valid,
    bool? isSubmitting,
  }) {
    return SubmissionPageState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isStep1Valid: isStep1Valid ?? this.isStep1Valid,
      isStep2Valid: isStep2Valid ?? this.isStep2Valid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// 유효성 검사 결과
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});
}

/// 벌점 사유 제출 페이지 상태 관리자
class SubmissionPageStateNotifier extends StateNotifier<SubmissionPageState> {
  SubmissionPageStateNotifier() : super(const SubmissionPageState());

  void setCurrentPageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  void setStep1Validation(bool isValid) {
    state = state.copyWith(isStep1Valid: isValid);
  }

  void setStep2Validation(bool isValid) {
    state = state.copyWith(isStep2Valid: isValid);
  }

  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  void reset() {
    state = const SubmissionPageState();
  }
}

/// 벌점 사유 제출 및 입력값 초기화 등 로직 담당 클래스
class PenaltySubmissionLogic {
  final Ref ref;
  PenaltySubmissionLogic(this.ref);

  /// 벌점 사유 입력값 전체 초기화
  void resetSubmissionData() {
    ref.read(selectedReasonProvider.notifier).state = null;
    ref.read(selectedDateProvider.notifier).state = DateTime.now();
    ref.read(selectedStartTimeProvider.notifier).state = _getDefaultTime();
    ref.read(selectedEndTimeProvider.notifier).state = _getDefaultTime();
    ref.read(reasonInputProvider.notifier).state = '';
    ref.read(selectedImagePathsProvider.notifier).state = [];
    ref.read(isAbsenceSelectedProvider.notifier).state = false;
  }

  /// 기본 시간 반환 헬퍼 함수
  DateTime _getDefaultTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 0, 0);
  }

  /// 기존 Penalty로 초기화
  void initializeWithPenalty(Penalty penalty) {
    ref.read(selectedReasonProvider.notifier).state = penalty.category;
    ref.read(selectedDateProvider.notifier).state = penalty.createdAt;
    ref.read(isAbsenceSelectedProvider.notifier).state =
        penalty.category == PenaltyCategory.absence;

    if (penalty.category == PenaltyCategory.absence) {
      ref.read(selectedStartTimeProvider.notifier).state = _getDefaultTime();
      ref.read(selectedEndTimeProvider.notifier).state = _getDefaultTime();
    }
  }

  /// 벌점 사유 제출 및 Penalty 상태 갱신
  /// [penalty] : 사유를 제출할 Penalty 객체 (null 가능)
  /// [onSuccess] : 성공 시 실행할 콜백
  /// [onError] : 에러 시 실행할 콜백
  Future<void> submitPenaltyReason({
    required Penalty? penalty,
    required Function onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      final repository = ref.read(penaltyReasonRepositoryProvider);
      final selectedReason = ref.read(selectedReasonProvider);
      final selectedDate = ref.read(selectedDateProvider);
      final selectedStartTime = ref.read(selectedStartTimeProvider);
      final selectedEndTime = ref.read(selectedEndTimeProvider);
      final reasonInput = ref.read(reasonInputProvider);
      final selectedImagePaths = ref.read(selectedImagePathsProvider);
      final now = DateTime.now();

      // 유효성 검사
      if (selectedReason == null) {
        throw Exception('사유가 선택되지 않았습니다.');
      }

      if (reasonInput.isEmpty) {
        throw Exception('벌점 사유가 입력되지 않았습니다.');
      }

      // PenaltyReason id 자동 증가
      final allReasons = await repository.getPenaltyReasons();
      int newId = 1;
      if (allReasons.isNotEmpty) {
        final maxId = allReasons
            .map((e) => int.tryParse(e.id) ?? 0)
            .reduce((a, b) => a > b ? a : b);
        newId = maxId + 1;
      }

      // PenaltyReason 객체 생성
      final penaltyReason = PenaltyReason(
        id: newId.toString(),
        category: selectedReason,
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

      // 저장소에 PenaltyReason 저장
      await repository.savePenaltyReason(penaltyReason);

      // 사유 새로고침 트리거 및 Provider 갱신
      ref.read(penaltyReasonsRefreshTrigger.notifier).state++;
      ref.read(penaltyReasonsProvider.notifier).refreshPenaltyReasons();

      // Penalty 객체가 있으면 상태 업데이트
      if (penalty != null) {
        log(
          'PenaltySubmissionLogic: Original penalty ID for update:  [33m${penalty.id} [0m',
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
        await ref
            .read(penaltiesProvider.notifier)
            .updatePenalty(updatedPenalty);
      }

      onSuccess();
    } catch (e) {
      log('PenaltySubmissionLogic: Error submitting penalty reason: $e');
      onError?.call(e.toString());
    }
  }

  /// Step 1 유효성 검사
  ValidationResult validateStep1() {
    final selectedReason = ref.read(selectedReasonProvider);
    final reasonInput = ref.read(reasonInputProvider);

    if (selectedReason == null) {
      return ValidationResult(isValid: false, errorMessage: '사유를 선택해주세요.');
    }

    if (reasonInput.isEmpty) {
      return ValidationResult(isValid: false, errorMessage: '벌점 사유를 입력해주세요.');
    }

    return ValidationResult(isValid: true);
  }

  /// Step 2 유효성 검사
  ValidationResult validateStep2() {
    return ValidationResult(isValid: true);
  }

  /// 벌점 점수 계산
  static int calculatePoints(PenaltyCategory? category) {
    if (category == PenaltyCategory.tardy ||
        category == PenaltyCategory.earlyLeave) {
      return 5;
    }
    return 10;
  }

  /// 새로운 ID 생성
  static String generateNewId(List<Penalty> penalties) {
    int newId = 1;
    if (penalties.isNotEmpty) {
      final maxId = penalties
          .map((e) => int.tryParse(e.id) ?? 0)
          .reduce((a, b) => a > b ? a : b);
      newId = maxId + 1;
    }
    return newId.toString();
  }

  /// Penalty 객체 생성
  static Penalty createPenalty({
    required String id,
    required PenaltyCategory category,
    required DateTime createdAt,
  }) {
    return Penalty(
      id: id,
      title: '',
      description: '',
      status: '승인대기',
      points: calculatePoints(category),
      category: category,
      createdAt: createdAt,
      isReasonSubmitted: true,
    );
  }

  /// 새로운 Penalty 생성
  Future<Penalty> createNewPenalty() async {
    final penalties = ref.read(penaltiesProvider);
    final selectedReason = ref.read(selectedReasonProvider);
    final newId = generateNewId(penalties);

    final penalty = createPenalty(
      id: newId,
      category: selectedReason ?? PenaltyCategory.learningAttitude,
      createdAt: DateTime.now(),
    );

    await ref.read(penaltiesProvider.notifier).addPenalty(penalty);
    final updatedPenalties = ref.read(penaltiesProvider);
    return updatedPenalties.firstWhere(
      (p) => p.id == penalty.id,
      orElse: () => penalty,
    );
  }
}
