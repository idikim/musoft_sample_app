import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:madezone_study_student_app/view/stack/stack_page.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:
            !Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(Icons.home_outlined),
                  onPressed: () {
                    Get.offAll(() => const StackPage());
                  },
                )
                : null,
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: true,
            javaScriptEnabled: true,
            userAgent:
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
          ),
          // WebView 네이티브 컴포넌트가 만들어지면 호출됨
          onWebViewCreated: (controller) {
            log('onWebViewCreated');
          },
          // 페이지 로딩이 시작될 때 호출됨
          onLoadStart: (controller, url) {
            log('onLoadStart');
          },
          // 페이지 로딩이 완료되면 호출됨
          onLoadStop: (controller, url) {
            log('onLoadStop');
          },
          // 웹뷰 내 웹 페이지에서 GPS, 카메라 등의 권한을 요청했을때 호출됨
          onPermissionRequest: (controller, request) async {
            log('onPermissionRequest');
            return null;
          },
        ),
      ),
    );
  }
}
