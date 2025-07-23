import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:musoft_sample_app/api/user_api.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';

class FcmHelper {
  static void Function(String url)? _onFcmTap;

  /// FCM 알림 클릭 콜백 등록
  static void setOnFcmTap(void Function(String url) callback) {
    _onFcmTap = callback;
  }

  /// 앱이 FCM 알림 클릭으로 시작된 경우 url 반환
  static Future<String?> getInitialFcmUrl() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    final url = initialMessage?.data['url'];
    return (url != null && url.isNotEmpty) ? url : null;
  }

  /// FCM 백그라운드 메시지 핸들러
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('Handling a background message: ${message.messageId}');
  }

  /// FCM 초기화 및 핸들러 등록
  static Future<void> initialize() async {
    // 권한 및 토큰 처리
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          final token = await FirebaseMessaging.instance.getToken();
          log('FCM Device Token: $token');
          if (token != null) {
            await UserApi.sendFcmToken(token, apnsToken: apnsToken);
          }
        } else {
          log('APNS 토큰을 받아오지 못했습니다.');
        }
      }
    } else {
      final token = await FirebaseMessaging.instance.getToken();
      log('FCM Device Token: $token');
      if (token != null) {
        await UserApi.sendFcmToken(token, apnsToken: null);
      }
    }

    // 토큰 갱신 리스너
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      log('FCM Token refreshed: $newToken');
      UserApi.sendFcmToken(newToken, apnsToken: null);
    });

    // 포그라운드 메시지 수신 시 로컬 알림 표시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final url = message.data['url'];
      final body = message.notification?.body ?? '';
      NotificationHelper.show(body, url: url);
    });

    // 알림 클릭 시 콜백 호출
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final url = message.data['url'];
      if (url != null && url.isNotEmpty && _onFcmTap != null) {
        _onFcmTap!(url);
      }
    });
  }

  /// FCM 전체 초기화 및 핸들러 등록
  static Future<void> initAll({
    void Function(String url)? onFcmTapCallback,
  }) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (onFcmTapCallback != null) setOnFcmTap(onFcmTapCallback);
    await initialize();
  }
}
