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
