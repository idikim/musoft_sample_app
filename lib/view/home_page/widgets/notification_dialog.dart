import 'package:flutter/material.dart';
import 'package:musoft_sample_app/model/notification.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width;

    final List<NotificationItem> notifications = [
      NotificationItem(title: '신규 공지사항', subtitle: '2024-06-10'),
      NotificationItem(title: '식사 신청 마감', subtitle: '2024-06-09'),
      NotificationItem(title: '상점 부여', subtitle: '2024-06-08'),
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      backgroundColor: Colors.white,
      title: const Text('알림 내역'),
      content: SizedBox(
        width: dialogWidth,
        height: 200,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blueGrey),
              title: Text(notification.title),
              subtitle: Text(notification.subtitle),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const NotificationDialog();
    },
  );
}
