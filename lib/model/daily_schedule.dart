enum ScheduleCategory { study, penalty }

class DailySchedule {
  final DateTime date;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String title;
  final List<String>? details;
  final ScheduleCategory category;

  DailySchedule({
    required this.date,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.title,
    this.details,
    this.category = ScheduleCategory.study,
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
      category: ScheduleCategory.values.firstWhere(
        (e) => e.name == (json['category'] as String?),
        orElse: () => ScheduleCategory.study,
      ),
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
    'category': category.name,
  };
}
