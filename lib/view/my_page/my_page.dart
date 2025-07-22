import 'package:flutter/material.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        elevation: 4,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.notifications_outlined),
        onPressed: () async {
          await NotificationHelper.show(
            'URL 연결테스트',
            url: 'https://frolicking-lebkuchen-4d0db6.netlify.app/fawefawe',
          );
        },
      ),
    );
  }
}
