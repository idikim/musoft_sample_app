import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // 백그라운드에서 푸시알림 클릭시 실행할 로직
// }
class NotificationHelper {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void Function(String url)? onNotificationTap;

  static void setOnNotificationTap(void Function(String url) callback) {
    onNotificationTap = callback;
  }

  /// 알림 권한 요청
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

  /// 알림 초기화
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
        if (noti.payload != null &&
            noti.payload!.isNotEmpty &&
            onNotificationTap != null) {
          onNotificationTap!(noti.payload!);
        }
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _requestAndroidPermissionForOver33();
  }

  /// 안드로이드 13 이상 권한 요청
  static Future<bool?> _requestAndroidPermissionForOver33() async {
    final androidNotificationPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    return await androidNotificationPlugin?.requestNotificationsPermission();
  }

  /// 알림 표시
  static Future<void> show(String content, {String? url}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;

    return flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      appName,
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
      payload: url ?? '',
    );
  }
}
