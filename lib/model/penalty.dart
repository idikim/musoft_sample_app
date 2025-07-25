import 'package:madezone_study_student_app/model/penalty_category.dart';

class Penalty {
  final String id;
  final String? title;
  final String? description;
  final String? status;
  final int points;
  final PenaltyCategory category;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? approvalDateTime;

  Penalty({
    required this.id,
    this.title,
    this.description,
    this.status,
    required this.points,
    required this.category,
    required this.createdAt,
    this.submittedAt,
    this.approvalDateTime,
  });

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      points: json['points'] as int,
      category: PenaltyCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => PenaltyCategory.learningAttitude,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      submittedAt:
          json['submittedAt'] != null
              ? DateTime.parse(json['submittedAt'] as String)
              : null,
      approvalDateTime:
          json['approvalDateTime'] != null
              ? DateTime.parse(json['approvalDateTime'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'points': points,
      'category': category.toString(),
      'createdAt': createdAt.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'approvalDateTime': approvalDateTime?.toIso8601String(),
    };
  }
}
