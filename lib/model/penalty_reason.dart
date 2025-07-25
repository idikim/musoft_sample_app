import 'package:madezone_study_student_app/model/penalty_category.dart';

class PenaltyReason {
  final String id;
  final PenaltyCategory category;
  final String penaltyId;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String? imageUrl;

  PenaltyReason({
    required this.id,
    required this.category,
    required this.penaltyId,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.imageUrl,
  });

  factory PenaltyReason.fromJson(Map<String, dynamic> json) {
    return PenaltyReason(
      id: json['id'],
      category: PenaltyCategory.fromString(json['category']),
      penaltyId: json['penaltyId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.displayName,
      'penaltyId': penaltyId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
