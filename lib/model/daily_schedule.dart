import 'package:flutter/material.dart';

class DailySchedule {
  final DateTime date;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String title;
  final List<String>? details;
  final Color color;

  DailySchedule({
    required this.date,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.title,
    this.details,
    required this.color,
  });

  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      date: DateTime.parse(json['date'] as String),
      startHour: json['startHour'] as int,
      startMinute: json['startMinute'] as int,
      endHour: json['endHour'] as int,
      endMinute: json['endMinute'] as int,
      title: json['title'] as String,
      details: (json['details'] as List?)?.map((e) => e as String).toList(),
      color: Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'title': title,
    'details': details,
    'color': color.value,
  };
}
