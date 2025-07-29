import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madezone_study_student_app/model/schedule_sample.dart';

class ScheduleSampleRepository {
  static const _key = 'schedule_samples';

  static Future<void> saveScheduleSamples(List<ScheduleSample> samples) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = samples.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<ScheduleSample>> loadScheduleSamples() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => ScheduleSample.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addSampleScheduleSamples(
    List<ScheduleSample> samples,
  ) async {
    final current = await loadScheduleSamples();
    final all = [...current, ...samples];
    await saveScheduleSamples(all);
  }

  static Future<void> clearScheduleSamples() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
