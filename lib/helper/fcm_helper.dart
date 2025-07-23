import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:musoft_sample_app/api/user_api.dart';
import 'package:musoft_sample_app/helper/notification_helper.dart';
import 'package:musoft_sample_app/view/my_page/web_view_page.dart';

class FcmHelper {
  static Future<void> initialize() async {
    // iOS에서의 별도 토큰 처리
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();

      NotificationSettings settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken != null) {
          String? token = await FirebaseMessaging.instance.getToken();
          log('FCM Device Token: $token');
          if (token != null) {
            await UserApi.sendFcmToken(token, apnsToken: apnsToken);
          }
        } else {
          log('APNS 토큰을 받아오지 못했습니다.');
        }
      }
    } else {
      String? token = await FirebaseMessaging.instance.getToken();
      log('FCM Device Token: $token');
      if (token != null) {
        await UserApi.sendFcmToken(token, apnsToken: null);
      }
    }

    // 토큰 갱신 리스너 등록
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

    // 알림 클릭(앱이 백그라운드/종료 상태) 시 url 이동
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final url = message.data['url'];
      if (url != null && url.isNotEmpty) {
        Get.to(() => WebViewPage(url: url));
      }
    });

    // 앱이 완전히 종료된 상태에서 알림 클릭으로 시작된 경우
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data['url'] != null &&
        initialMessage!.data['url'].isNotEmpty) {
      Get.to(() => WebViewPage(url: initialMessage.data['url']));
    }
  }
}
