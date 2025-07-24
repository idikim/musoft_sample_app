import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';

class PenaltyReasonRepository {
  static const String _key = 'penaltyReasons';

  Future<List<PenaltyReason>> getPenaltyReasons() async {
    final prefs = await SharedPreferences.getInstance();
    final String? penaltyReasonsString = prefs.getString(_key);

    if (penaltyReasonsString == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(penaltyReasonsString);
    return jsonList.map((json) => PenaltyReason.fromJson(json)).toList();
  }

  Future<void> savePenaltyReason(PenaltyReason penaltyReason) async {
    final prefs = await SharedPreferences.getInstance();
    final List<PenaltyReason> currentReasons = await getPenaltyReasons();
    currentReasons.add(penaltyReason);
    final String encodedData = json.encode(currentReasons.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encodedData);
  }

  Future<void> updatePenaltyReason(PenaltyReason updatedPenaltyReason) async {
    final prefs = await SharedPreferences.getInstance();
    List<PenaltyReason> currentReasons = await getPenaltyReasons();
    final index = currentReasons.indexWhere((reason) => reason.id == updatedPenaltyReason.id);
    if (index != -1) {
      currentReasons[index] = updatedPenaltyReason;
      final String encodedData = json.encode(currentReasons.map((e) => e.toJson()).toList());
      await prefs.setString(_key, encodedData);
    }
  }

  Future<void> deletePenaltyReason(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<PenaltyReason> currentReasons = await getPenaltyReasons();
    currentReasons.removeWhere((reason) => reason.id == id);
    final String encodedData = json.encode(currentReasons.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encodedData);
  }
}
