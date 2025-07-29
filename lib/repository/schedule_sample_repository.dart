import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';

class DailyScheduleRepository {
  static const _key = 'schedule_samples';

  static Future<void> saveDailySchedules(List<DailySchedule> samples) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = samples.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<DailySchedule>> loadDailySchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => DailySchedule.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addSampleDailySchedules(
    List<DailySchedule> samples,
  ) async {
    final current = await loadDailySchedules();
    final all = [...current, ...samples];
    await saveDailySchedules(all);
  }

  static Future<void> clearDailySchedules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
