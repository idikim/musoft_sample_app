import 'package:flutter/material.dart';

class ScheduleSample {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String title;
  final String? subtitle;
  final List<String>? details;
  final Color color;

  ScheduleSample({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.title,
    this.subtitle,
    this.details,
    required this.color,
  });

  factory ScheduleSample.fromJson(Map<String, dynamic> json) {
    return ScheduleSample(
      startHour: json['startHour'] as int,
      startMinute: json['startMinute'] as int,
      endHour: json['endHour'] as int,
      endMinute: json['endMinute'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      details: (json['details'] as List?)?.map((e) => e as String).toList(),
      color: Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'title': title,
    'subtitle': subtitle,
    'details': details,
    'color': color.value,
  };
}
