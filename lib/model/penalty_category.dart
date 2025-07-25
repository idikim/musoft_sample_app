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
