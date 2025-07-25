import 'package:madezone_study_student_app/model/penalty_category.dart';

class PenaltyReason {
  final String id;
  final PenaltyCategory category;
  final String penaltyId;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String userReason;
  final String? imageUrl;
  final DateTime? submittedAt;

  PenaltyReason({
    required this.id,
    required this.category,
    required this.penaltyId,
    required this.startDate,
    required this.endDate,
    this.description,
    required this.userReason,
    this.imageUrl,
    this.submittedAt,
  });

  factory PenaltyReason.fromJson(Map<String, dynamic> json) {
    return PenaltyReason(
      id: json['id'],
      category: PenaltyCategory.fromString(json['category']),
      penaltyId: json['penaltyId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'] ?? '',
      userReason: json['userReason'] ?? '',
      imageUrl: json['imageUrl'],
      submittedAt:
          json['submittedAt'] != null
              ? DateTime.parse(json['submittedAt'])
              : null,
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
      'userReason': userReason,
      'imageUrl': imageUrl,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }
}
