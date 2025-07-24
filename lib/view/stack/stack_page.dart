import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/counsel_page/counsel_page.dart';
import 'package:madezone_study_student_app/view/learning_page/learning_page.dart';
import 'package:madezone_study_student_app/view/life_page/life_page.dart';
import 'package:madezone_study_student_app/view/my_page/my_page.dart';
import 'package:madezone_study_student_app/view/stack/widgets/bottom_navigation.dart';
import 'package:madezone_study_student_app/view/home_page/home_page.dart';
import 'package:madezone_study_student_app/view/home_page/notification/notification_page.dart';
import 'package:madezone_study_student_app/view/widgets/animated_page_wrapper.dart';

class StackPage extends StatefulWidget {
  const StackPage({super.key});

  @override
  State<StackPage> createState() => StackPageState();
}

class StackPageState extends State<StackPage> {
  int _currentIndex = 0;
  bool _showNotificationPage = false;
  bool _notificationPageFullyVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _screens[_currentIndex],
          AnimatedPageWrapper(
            isShown: _showNotificationPage,
            isFullyVisible: _notificationPageFullyVisible,
            child: NotificationPage(onBack: hideNotificationPage),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

