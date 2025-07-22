import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';
import 'package:musoft_sample_app/view/stack/stack_page.dart';
import 'package:musoft_sample_app/view/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await NotificationHelper.requestPermission();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: const StackPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
