import 'package:flutter/material.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        child: Center(child: Icon(Icons.notifications_outlined)),
        onPressed: () async {
          await NotificationHelper.show('title', 'content');
        },
      ),
    );
  }
}
