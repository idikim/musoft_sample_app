import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/repository/penalty_reason_repository.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/local_penalty_data.dart';
import 'package:path_provider/path_provider.dart';

/// 전체 Penalty 리스트 관리 Provider
final penaltiesProvider =
    StateNotifierProvider<PenaltiesNotifier, List<Penalty>>(
      (ref) => PenaltiesNotifier(ref),
    );

/// PenaltyReason 리스트 관리 Provider
final penaltyReasonsProvider = StateNotifierProvider<
  PenaltyReasonsNotifier,
  List<PenaltyReason>
>((ref) => PenaltyReasonsNotifier(ref.read(penaltyReasonRepositoryProvider)));

/// Penalty(벌점) 리스트 관리
class PenaltiesNotifier extends StateNotifier<List<Penalty>> {
  final Ref _ref;
  PenaltiesNotifier(this._ref) : super([]) {
    _loadPenalties();
  }

  /// 앱의 로컬 저장소 경로 반환
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// penalties.json 파일 객체 반환
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/penalties.json');
  }

  /// penalties.json에서 Penalty 리스트를 불러와 state에 반영
  Future<List<Penalty>> _loadPenalties() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      final loadedPenalties =
          jsonList.map((json) => Penalty.fromJson(json)).toList();

      state = loadedPenalties;
      return state;
    } catch (e) {
      log('Error loading penalties: $e');
      return [];
    }
  }

  /// Penalty 리스트를 penalties.json에 저장
  Future<File> savePenalties(List<Penalty> penalties) async {
    final file = await _localFile;
    final jsonList = penalties.map((penalty) => penalty.toJson()).toList();
    return file.writeAsString(jsonEncode(jsonList));
  }

  /// 특정 Penalty를 업데이트(수정)하고 저장
  Future<void> updatePenalty(Penalty updatedPenalty) async {
    state = [
      for (final p in state)
        if (p.id == updatedPenalty.id) updatedPenalty else p,
    ];
    await savePenalties(state);
  }

  /// Penalty를 새로 추가하고 저장
  Future<void> addPenalty(Penalty newPenalty) async {
    state = [...state, newPenalty];
    await savePenalties(state);
  }

  /// 샘플 Penalty 데터를 추가하고 저장
  Future<void> addSamplePenalties() async {
    final samplePenalties = getPenaltiesForMonth(0);
    state = samplePenalties;
    await savePenalties(state);

    _ref.read(penaltyReasonsProvider.notifier).addSamplePenaltyReasons();
  }

  /// Penalty 리스트를 새로고침(파일에서 다시 불러옴)
  Future<void> refreshPenalties() async {
    await _loadPenalties();
  }
}

/// PenaltyReason(사유) 리스트 관리
class PenaltyReasonsNotifier extends StateNotifier<List<PenaltyReason>> {
  final PenaltyReasonRepository _repository;
  PenaltyReasonsNotifier(this._repository) : super([]) {
    _loadPenaltyReasons();
  }

  /// 저장소에서 PenaltyReason 리스트를 불러와 state에 반영
  Future<void> _loadPenaltyReasons() async {
    try {
      state = await _repository.getPenaltyReasons();
    } catch (e) {
      log('Error loading penalty reasons: $e');
      state = [];
    }
  }

  /// 샘플 PenaltyReason 데이터를 추가하고 state 갱신
  Future<void> addSamplePenaltyReasons() async {
    final samplePenaltyReasons = getPenaltyReasonsForMonth(0);
    for (var reason in samplePenaltyReasons) {
      await _repository.savePenaltyReason(reason);
    }
    await _loadPenaltyReasons();
  }

  /// PenaltyReason 리스트를 새로고침(저장소에서 다시 불러옴)
  Future<void> refreshPenaltyReasons() async {
    await _loadPenaltyReasons();
  }
}
