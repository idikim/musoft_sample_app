import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:madezone_study_student_app/helper/fcm_helper.dart';
import 'package:madezone_study_student_app/helper/notification_helper.dart';
import 'package:madezone_study_student_app/view/my_page/web_view_page.dart';
import 'package:madezone_study_student_app/view/stack/stack_page.dart';
import 'package:madezone_study_student_app/view/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ko_KR', null);

  await NotificationHelper.initAll(
    onNotificationTapCallback: (url) {
      Get.to(() => WebViewPage(url: url));
    },
  );
  await FcmHelper.initAll(
    onFcmTapCallback: (url) {
      Get.to(() => WebViewPage(url: url));
    },
  );

  String? initialUrl =
      await NotificationHelper.getInitialLocalNotificationUrl();
  final fcmUrl = await FcmHelper.getInitialFcmUrl();
  if (fcmUrl != null && fcmUrl.isNotEmpty) {
    initialUrl = fcmUrl;
  }

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ko', '')],
    );
  }
}
