import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // 백그라운드에서 푸시알림 클릭시 실행할 로직
}

class NotificationHelper {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.notification.request();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (noti) {
        // 포그라운드에서 알림 터치했을 때
        print(noti.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _requestAndroidPermissionForOver33();
  }

  static Future<bool?> _requestAndroidPermissionForOver33() async {
    final androidNotificationPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    return await androidNotificationPlugin?.requestNotificationsPermission();
  }

  static Future<void> show(String title, String content) async {
    return flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      title, // 알림 제목
      content, // 알림 내용
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test channel id', // 알림 분류값
          'General Notifications', // 알림 채널명
          importance: Importance.high, // 알림의 우선순위
          playSound: true, // 알림 소리 재생 여부
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true, // 알림 소리 재생 여부
          presentAlert: true, // 알림 표시 여부
          presentBadge: true, // 배지 표시 여부
        ),
      ),
      payload: 'Open from Local Notification',
    );
  }
}
