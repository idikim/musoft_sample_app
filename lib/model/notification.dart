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
