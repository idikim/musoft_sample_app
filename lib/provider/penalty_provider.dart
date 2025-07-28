import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/repository/penalty_reason_repository.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/local_penalty_data.dart';
import 'package:path_provider/path_provider.dart';

final penaltiesProvider =
    StateNotifierProvider<PenaltiesNotifier, List<Penalty>>(
      (ref) => PenaltiesNotifier(ref),
    );

final penaltyReasonsProvider = StateNotifierProvider<
  PenaltyReasonsNotifier,
  List<PenaltyReason>
>((ref) => PenaltyReasonsNotifier(ref.read(penaltyReasonRepositoryProvider)));

class PenaltiesNotifier extends StateNotifier<List<Penalty>> {
  final Ref _ref;
  PenaltiesNotifier(this._ref) : super([]) {
    _loadPenalties();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/penalties.json');
  }

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

  Future<File> savePenalties(List<Penalty> penalties) async {
    final file = await _localFile;
    final jsonList = penalties.map((penalty) => penalty.toJson()).toList();
    return file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> updatePenalty(Penalty updatedPenalty) async {
    state = [
      for (final p in state)
        if (p.id == updatedPenalty.id) updatedPenalty else p,
    ];
    await savePenalties(state);
  }

  Future<void> addSamplePenalties() async {
    final samplePenalties = getPenaltiesForMonth(0);
    state = samplePenalties;
    await savePenalties(state);

    _ref.read(penaltyReasonsProvider.notifier).addSamplePenaltyReasons();
  }

  Future<void> refreshPenalties() async {
    await _loadPenalties();
  }
}

class PenaltyReasonsNotifier extends StateNotifier<List<PenaltyReason>> {
  final PenaltyReasonRepository _repository;
  PenaltyReasonsNotifier(this._repository) : super([]) {
    _loadPenaltyReasons();
  }

  Future<void> _loadPenaltyReasons() async {
    try {
      state = await _repository.getPenaltyReasons();
    } catch (e) {
      log('Error loading penalty reasons: $e');
      state = [];
    }
  }

  Future<void> addSamplePenaltyReasons() async {
    final samplePenaltyReasons = getPenaltyReasonsForMonth(0);
    for (var reason in samplePenaltyReasons) {
      await _repository.savePenaltyReason(reason);
    }
    await _loadPenaltyReasons();
  }

  Future<void> refreshPenaltyReasons() async {
    await _loadPenaltyReasons();
  }
}
