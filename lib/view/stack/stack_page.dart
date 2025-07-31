import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/navigation_providers.dart';
import 'package:madezone_study_student_app/view/counsel_page/counsel_page.dart';
import 'package:madezone_study_student_app/view/learning_page/learning_page.dart';
import 'package:madezone_study_student_app/view/life_page/life_page.dart';
import 'package:madezone_study_student_app/view/my_page/my_page.dart';
import 'package:madezone_study_student_app/view/stack/widgets/bottom_navigation.dart';
import 'package:madezone_study_student_app/view/home_page/home_page.dart';
import 'package:madezone_study_student_app/view/home_page/notification/notification_page.dart';
import 'package:madezone_study_student_app/view/widgets/animated_page_wrapper.dart';
import 'package:get/get.dart';

class StackPage extends ConsumerStatefulWidget {
  const StackPage({super.key});

  @override
  ConsumerState<StackPage> createState() => StackPageState();
}

class StackPageState extends ConsumerState<StackPage> {
  bool _showNotificationPage = false;
  bool _notificationPageFullyVisible = false;

  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = const [
    HomePage(),
    LearningPage(),
    LifePage(),
    CounselPage(),
    MyPage(),
  ];

  void showNotificationPage() {
    setState(() {
      _showNotificationPage = true;
      _notificationPageFullyVisible = true;
    });
  }

  void hideNotificationPage() {
    setState(() {
      _showNotificationPage = false;
    });
    Future.delayed(AnimatedPageWrapper.pageTransitionDuration, () {
      if (mounted) {
        setState(() {
          _notificationPageFullyVisible = false;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_showNotificationPage) {
      hideNotificationPage();
      return false;
    }

    if (Platform.isAndroid) {
      final now = DateTime.now();
      if (_lastPressedAt == null ||
          now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
        _lastPressedAt = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('한 번 더 누르시면 앱이 종료됩니다.'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      Get.back();
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(stackPageIndexProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _screens[currentIndex],
            AnimatedPageWrapper(
              isShown: _showNotificationPage,
              isFullyVisible: _notificationPageFullyVisible,
              child: NotificationPage(onBack: hideNotificationPage),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentIndex: currentIndex,
          onTap: (i) => ref.read(stackPageIndexProvider.notifier).state = i,
        ),
      ),
    );
  }
}
