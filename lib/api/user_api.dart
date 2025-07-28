import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<void> sendFcmToken(String token, {String? apnsToken}) async {
    if (kIsWeb) {
      return;
    }

    if (await _isPhysicalDevice()) {
      return;
    }

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

  static Future<bool> _isPhysicalDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice;
    }
    return true;
  }
}
