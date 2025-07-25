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
}
