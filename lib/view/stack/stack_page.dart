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

class StackPage extends ConsumerStatefulWidget {
  const StackPage({super.key});

  @override
  ConsumerState<StackPage> createState() => StackPageState();
}

class StackPageState extends ConsumerState<StackPage> {
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
    final currentIndex = ref.watch(stackPageIndexProvider);

    return Scaffold(
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
    );
  }
}

