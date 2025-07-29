import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/notice.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final VoidCallback onBack;
  const NotificationPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: '신규 공지사항',
        date: DateTime(2024, 6, 10),
        // content: '새로운 공지사항이 등록되었습니다.',
      ),
      NotificationItem(
        title: '식사 신청 마감',
        date: DateTime(2024, 6, 9),
        content: '오늘은 식사 신청 마감일입니다.',
      ),
      NotificationItem(
        title: '상점 부여',
        date: DateTime(2024, 6, 8),
        content: '상점이 부여되었습니다. 자세한 내용을 확인하세요.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 내역'),
        centerTitle: true,
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Row(
              children: [
                Text(notification.title, style: TextStyle(fontSize: 16)),
                Spacer(),
                Text(
                  DateFormat('yyyy-MM-dd').format(notification.date!),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            subtitle:
                notification.content != null
                    ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        notification.content!,
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    )
                    : null,
          );
        },
        separatorBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(height: 1),
            ),
      ),
    );
  }
}
