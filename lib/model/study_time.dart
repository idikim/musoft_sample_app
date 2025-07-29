class StudyTime {
  final DateTime date;
  final int minutes;

  StudyTime({required this.date, required this.minutes});

  factory StudyTime.fromJson(Map<String, dynamic> json) {
    return StudyTime(
      date: DateTime.parse(json['date'] as String),
      minutes: json['minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'minutes': minutes,
  };
}

enum StudyTimeType { daily, weekly, monthly }
