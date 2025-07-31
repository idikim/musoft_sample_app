import 'dart:convert';
import 'package:madezone_study_student_app/model/daily_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyScheduleRepository {
  static const String _schedulesKey = 'dailySchedules';

  static Future<List<DailySchedule>> loadDailySchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? schedulesJson = prefs.getString(_schedulesKey);
    if (schedulesJson == null) {
      return [];
    }
    final List<dynamic> decodedData = json.decode(schedulesJson) as List;
    return decodedData
        .map((json) => DailySchedule.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addDailySchedule(DailySchedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final List<DailySchedule> currentSchedules = await loadDailySchedules();
    currentSchedules.add(schedule);
    final String encodedData = json.encode(
      currentSchedules.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_schedulesKey, encodedData);
  }

  static Future<void> clearDailySchedules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_schedulesKey);
  }
}