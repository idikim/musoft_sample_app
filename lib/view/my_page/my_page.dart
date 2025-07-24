import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:madezone_study_student_app/helper/notification_helper.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'notification_fab',
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
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'delete_fab',
            elevation: 4,
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.delete_outlined),
            onPressed: () async {
              await InAppWebViewController.clearAllCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('웹뷰 캐시가 초기화되었습니다.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
