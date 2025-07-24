class Penalty {
  final DateTime date;
  final String? reason;
  final int points;
  final String category;
  final String status;

  Penalty({
    required this.date,
    this.reason,
    required this.points,
    required this.category,
    required this.status,
  });
}
