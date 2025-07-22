import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const NotificationDialog();
    },
  );
}

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      backgroundColor: Colors.white,
      title: const Text('알림 내역'),
      content: SizedBox(
        width: dialogWidth,
        height: 200,
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('신규 공지사항'),
              subtitle: Text('2024-06-10'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('식사 신청 마감'),
              subtitle: Text('2024-06-09'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('상점 부여'),
              subtitle: Text('2024-06-08'),
            ),
          ],
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
