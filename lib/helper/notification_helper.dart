import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void Function(String url)? _onNotificationTap;

  /// 로컬 알림 클릭 콜백 등록
  static void setOnNotificationTap(void Function(String url) callback) {
    _onNotificationTap = callback;
  }

  /// 앱이 로컬 알림 클릭으로 시작된 경우 url 반환
  static Future<String?> getInitialLocalNotificationUrl() async {
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    return details?.notificationResponse?.payload;
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
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (noti) {
        if (noti.payload != null &&
            noti.payload!.isNotEmpty &&
            _onNotificationTap != null) {
          _onNotificationTap!(noti.payload!);
        }
      },
    );

    await _requestAndroidPermissionForOver33();

    // Android 알림 채널 생성
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'default_channel',
        '기본 알림',
        description: '기본 푸시 알림 채널',
        importance: Importance.high,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  /// 안드로이드 13 이상 권한 요청
  static Future<bool?> _requestAndroidPermissionForOver33() async {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    return await androidPlugin?.requestNotificationsPermission();
  }

  /// 알림 표시
  static Future<void> show(String content, {String? url}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;

    return flutterLocalNotificationsPlugin.show(
      0,
      appName,
      content,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      payload: url ?? '',
    );
  }

  /// 로컬 알림 전체 초기화 및 핸들러 등록
  static Future<void> initAll({
    void Function(String url)? onNotificationTapCallback,
  }) async {
    await initialize();
    await requestPermission();
    if (onNotificationTapCallback != null)
      setOnNotificationTap(onNotificationTapCallback);
  }
}
