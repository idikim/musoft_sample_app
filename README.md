# FCM 기반 푸시알림 URL 연동 상세 가이드

이 문서는 Firebase Cloud Messaging(FCM)을 활용하여 서버에서 모바일 앱으로 푸시알림을 전송하고, 알림 클릭 시 앱 내 웹뷰(WebViewPage)로 특정 URL을 이동시키는 전체 연동 구조와 구현 방법을 실제 코드 구조에 맞게 설명합니다.

---

## 1. 전체 아키텍처 및 흐름

1. 앱이 실행되면 FCM 토큰을 발급받아 서버에 전달합니다.
2. 서버는 이 토큰을 저장해둡니다.
3. 서버가 푸시알림을 보내고 싶을 때, FCM 서버에 알림(제목/내용/URL 포함)을 요청합니다.
4. FCM 서버가 해당 앱 사용자에게 알림을 전달합니다.
5. 사용자가 알림을 클릭하면, 앱이 해당 URL로 이동합니다.

---

## 2. 사용 라이브러리 및 환경

- **firebase_messaging**: FCM 푸시알림 수신
- **flutter_local_notifications**: 포그라운드 알림 표시
- **flutter_inappwebview**: 앱 내 웹뷰
- **get**: 페이지 라우팅
- **permission_handler**: 알림 권한 요청
- **http**: 서버와 통신(FCM 토큰 전송)

`pubspec.yaml` :
```yaml
dependencies:
  firebase_messaging: ^15.2.10
  flutter_local_notifications: ^19.3.1
  flutter_inappwebview: ^6.1.5
  get: ^4.7.2
  permission_handler: ^12.0.1
  http: ^1.4.0
```

---

## 3. 앱 구현 상세

### 3.1. FCM 토큰 발급 및 서버 전송

#### 1) 토큰 발급 및 서버 전송
- 앱 실행 시 FCM 토큰을 발급받아 서버로 전송합니다.
- 토큰이 갱신될 때마다 서버로 갱신된 토큰을 전송합니다.
- iOS의 경우 apnsToken도 함께 전송합니다.

```dart
// lib/api/user_api.dart
import 'dart:developer';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<void> sendFcmToken(String token, {String? apnsToken}) async {
    try {
      await http.post(
        Uri.parse('http://10.0.2.2:8080/api/user/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: '{"token": "$token"}',
      );
    } catch (e) {
      log('sendFcmToken error: $e');
    }
  }
}
```

#### 2) FCM 초기화 및 핸들러 등록
- FCM 토큰 발급, 갱신, 알림 수신 및 클릭 이벤트를 처리합니다.
- 콜백 등록 및 초기화는 `FcmHelper.initAll`을 사용합니다.

```dart
// lib/helper/fcm_helper.dart
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:madezone_study_student_app/api/user_api.dart';
import 'package:madezone_study_student_app/helper/notification_helper.dart';

class FcmHelper {
  static void Function(String url)? _onFcmTap;

  static void setOnFcmTap(void Function(String url) callback) {
    _onFcmTap = callback;
  }

  static Future<String?> getInitialFcmUrl() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    final url = initialMessage?.data['url'];
    return (url != null && url.isNotEmpty) ? url : null;
  }

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

  static Future<void> initAll({
    void Function(String url)? onFcmTapCallback,
  }) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (onFcmTapCallback != null) setOnFcmTap(onFcmTapCallback);
    await initialize();
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('Handling a background message: \\${message.messageId}');
  }
}
```

#### 3) NotificationHelper 초기화 및 콜백 등록
- 포그라운드 알림 표시, 권한 요청, 클릭 콜백 등록 등 담당

```dart
// lib/helper/notification_helper.dart
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void Function(String url)? _onNotificationTap;

  static void setOnNotificationTap(void Function(String url) callback) {
    _onNotificationTap = callback;
  }

  static Future<String?> getInitialLocalNotificationUrl() async {
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    return details?.notificationResponse?.payload;
  }

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
    // ... (생략: 실제 코드 참고)
  }

  static Future<void> initAll({
    void Function(String url)? onNotificationTapCallback,
  }) async {
    await initialize();
    await requestPermission();
    if (onNotificationTapCallback != null)
      setOnNotificationTap(onNotificationTapCallback);
  }
}
```

#### 4) main.dart에서 전체 초기화 및 URL 처리
- 앱 시작 시 알림 클릭/FCM 클릭으로 전달된 URL을 받아 웹뷰로 이동

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
```

---

### 3.2. NotificationHelper 역할
- 포그라운드에서 알림을 표시하고, 알림 탭 시 콜백을 실행합니다.
- setOnNotificationTap으로 알림 탭 시 동작을 등록합니다.
- 백그라운드/종료 상태는 FcmHelper에서 직접 처리합니다.

---

## 4. 서버 연동 및 푸시알림 전송

### 4.1. 서버에서 FCM 토큰 저장
- 앱에서 전송한 FCM 토큰을 사용자 계정과 매핑하여 DB에 저장합니다.
- 토큰이 갱신될 때마다 갱신된 토큰으로 업데이트합니다.

### 4.2. 서버에서 FCM 푸시알림 전송
- 서버는 FCM HTTP v1 API 또는 레거시 API를 통해 아래와 같이 요청을 보냅니다.

```json
{
  "to": "<device_token>",
  "notification": {
    "title": "제목",
    "body": "내용"
  },
  "data": {
    "url": "https://example.com"
  }
}
```
- `to`: 앱에서 발급받아 서버에 저장된 디바이스 토큰
- `notification`: 사용자에게 표시될 알림의 제목/내용
- `data.url`: 알림 탭 시 앱에서 이동할 URL

#### 참고: 여러 명에게 보낼 경우
```json
{
  "registration_ids": ["token1", "token2", ...],
  ...
}
```

---

## 5. 백엔드 개발 요청사항

1. **FCM 토큰 저장용 엔드포인트 구현**
   - 예시: `POST /api/user/fcm-token`
   - 요청 body: `{ "token": "<FCM_DEVICE_TOKEN>" }`
   - 토큰을 사용자 계정과 매핑하여 DB에 저장/갱신

2. **FCM 푸시알림 전송 로직 구현**
   - 저장된 토큰을 이용해 FCM 서버로 알림 전송
   - 알림 전송 시, 반드시 data에 url을 포함
   - 예시 요청:
     ```json
     {
       "to": "<device_token>",
       "notification": {
         "title": "제목",
         "body": "내용"
       },
       "data": {
         "url": "https://example.com"
       }
     }
     ```
   - 여러 명에게 보낼 경우 `registration_ids` 사용 가능

3. **운영 시 주의사항**
   - 토큰 만료/갱신, 사용자 로그아웃 등 예외 상황 처리
   - FCM 서버 인증키 관리 및 보안 유지

---

## 6. 플랫폼별 설정 및 주의사항

### 6.1. Android
- **AndroidManifest.xml**
  - 알림 권한, 리시버, launchMode(singleTop) 등 설정 필요
  ```xml
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.VIBRATE" />
  <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
  <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" />
    
  <activity
      android:showWhenLocked="true"
      android:turnScreenOn="true">
  ```
- **리시버 등록**: flutter_local_notifications 관련 리시버 등록 필요
    ```xml
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver" />
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
            <action android:name="android.intent.action.QUICKBOOT_POWERON" />
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
        </intent-filter>
    </receiver>
    ```
- **targetSdkVersion**: 33 이상에서는 POST_NOTIFICATIONS 권한 필수

### 6.2. iOS
- **AppDelegate.swift**
  - 알림 플러그인 등록 및 UNUserNotificationCenter delegate 설정 필요
    ```swift
    import Flutter
    import UIKit
    import flutter_local_notifications

    @main
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
        }
        if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    }
    ```
- **권한 요청**: iOS 10 이상에서 알림 권한 요청 필요

---

## 7. 테스트 및 운영 체크리스트

- [ ] 앱에서 FCM 토큰이 정상적으로 발급되고 서버로 전송되는지 확인
- [ ] 서버에서 토큰을 정상적으로 저장/갱신하는지 확인
- [ ] 서버에서 FCM으로 알림 전송 시, 앱에서 알림을 정상적으로 수신하는지 확인
- [ ] 알림 클릭 시, 앱이 포그라운드/백그라운드/종료 상태 모두에서 URL로 이동하는지 확인
- [ ] Android/iOS 권한 및 매니페스트 설정이 올바른지 점검
- [ ] (운영) 토큰 만료/갱신, 사용자 로그아웃 등 예외 상황 처리

---

## 8. 참고자료

- [Firebase Cloud Messaging 공식 문서](https://firebase.google.com/docs/cloud-messaging)
- [flutter_local_notifications 공식 문서](https://pub.dev/packages/flutter_local_notifications)
- [firebase_messaging 공식 문서](https://pub.dev/packages/firebase_messaging)
- [FCM HTTP v1 API 가이드](https://firebase.google.com/docs/cloud-messaging/send-message)