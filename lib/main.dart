import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';
import 'package:musoft_sample_app/view/my_page/web_view_page.dart';
import 'package:musoft_sample_app/view/stack/stack_page.dart';
import 'package:musoft_sample_app/view/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await NotificationHelper.requestPermission();

  final details =
      await NotificationHelper.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
  String? initialUrl = details?.notificationResponse?.payload;

  NotificationHelper.setOnNotificationTap((url) {
    Get.to(() => WebViewPage(url: url));
  });
  runApp(ProviderScope(child: MyApp(initialUrl: initialUrl)));
}

class MyApp extends StatelessWidget {
  final String? initialUrl;
  const MyApp({super.key, this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.themeData,
      home:
          initialUrl != null && initialUrl!.isNotEmpty
              ? WebViewPage(url: initialUrl!)
              : const StackPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
