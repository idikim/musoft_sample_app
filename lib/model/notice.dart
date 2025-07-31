class NoticePost {
  final String title;
  final DateTime date;
  final String category;
  final String content;

  const NoticePost({
    required this.title,
    required this.date,
    required this.category,
    required this.content,
  });
}

class NotificationItem {
  final String title;
  final String? subtitle;
  final DateTime? date;
  final String? content;

  NotificationItem({
    required this.title,
    this.subtitle,
    this.date,
    this.content,
  });
}
