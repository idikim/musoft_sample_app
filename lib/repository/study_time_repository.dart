import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madezone_study_student_app/model/study_time.dart';

class StudyTimeRepository {
  static const _key = 'study_times';

  static Future<void> saveStudyTimes(List<StudyTime> studyTimes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = studyTimes.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<StudyTime>> loadStudyTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => StudyTime.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addSampleStudyTimes(List<StudyTime> samples) async {
    final current = await loadStudyTimes();
    final all = [...current, ...samples];
    await saveStudyTimes(all);
  }

  static Future<void> clearStudyTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
