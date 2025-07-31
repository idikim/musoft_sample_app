class Penalty {
  final String id;
  final String? title;
  final String? description;
  final String? status;
  final int points;
  final PenaltyCategory category;
  final DateTime createdAt;
  final bool isReasonSubmitted;
  final DateTime? approvalDateTime;

  Penalty({
    required this.id,
    this.title,
    this.description,
    this.status,
    required this.points,
    required this.category,
    required this.createdAt,
    this.isReasonSubmitted = false,
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
      isReasonSubmitted: json['isReasonSubmitted'] as bool? ?? false,
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
      'isReasonSubmitted': isReasonSubmitted,
      'approvalDateTime': approvalDateTime?.toIso8601String(),
    };
  }
}

class PenaltyReason {
  final String id;
  final PenaltyCategory category;
  final String penaltyId;
  final DateTime startDate;
  final DateTime endDate;
  final String userReason;
  final List<String>? imageUrls;
  final DateTime? submittedAt;

  PenaltyReason({
    required this.id,
    required this.category,
    required this.penaltyId,
    required this.startDate,
    required this.endDate,
    required this.userReason,
    this.imageUrls,
    this.submittedAt,
  });

  factory PenaltyReason.fromJson(Map<String, dynamic> json) {
    return PenaltyReason(
      id: json['id'],
      category: PenaltyCategory.fromString(json['category']),
      penaltyId: json['penaltyId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      userReason: json['userReason'] ?? '',
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
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
      'userReason': userReason,
      'imageUrls': imageUrls,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }
}

enum PenaltyCategory {
  absence('결석'),
  tardy('지각'),
  outing('외출'),
  earlyLeave('조퇴'),
  learningAttitude('학습태도');

  final String displayName;
  const PenaltyCategory(this.displayName);

  factory PenaltyCategory.fromString(String category) {
    switch (category) {
      case '결석':
        return PenaltyCategory.absence;
      case '지각':
        return PenaltyCategory.tardy;
      case '외출':
        return PenaltyCategory.outing;
      case '조퇴':
        return PenaltyCategory.earlyLeave;
      case '학습태도':
        return PenaltyCategory.learningAttitude;
      default:
        throw ArgumentError('Invalid PenaltyCategory string: $category');
    }
  }
}
