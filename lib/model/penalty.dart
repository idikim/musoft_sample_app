class Penalty {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final int points;
  final String category;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? approvalDateTime;

  Penalty({
    this.id,
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
