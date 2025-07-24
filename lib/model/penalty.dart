class Penalty {
  final String id;
  final String title;
  final String? description;
  final String status;
  final int points;
  final String category;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? approvalDateTime;

  Penalty({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.points,
    required this.category,
    required this.createdAt,
    this.submittedAt,
    this.approvalDateTime,
  });
}
