import 'package:flutter/material.dart';
import 'package:musoft_sample_app/view/counsel_page/counsel_page.dart';
import 'package:musoft_sample_app/view/learning_page/learning_page.dart';
import 'package:musoft_sample_app/view/life_page/life_page.dart';
import 'package:musoft_sample_app/view/my_page/my_page.dart';
import 'package:musoft_sample_app/view/stack/widgets/bottom_navigation.dart';
import 'package:musoft_sample_app/view/home_page/home_page.dart';

class StackPage extends StatefulWidget {
  const StackPage({super.key});

  @override
  State<StackPage> createState() => _StackPageState();
}

class _StackPageState extends State<StackPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    LearningPage(),
    LifePage(),
    CounselPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
