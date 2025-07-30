import 'package:flutter/material.dart';
import 'widgets/life_tabs.dart';
import 'study_time/study_time_page.dart';
import 'phone_submission_page.dart';
import 'patrol_result/patrol_result_page.dart';
import 'attendance_page.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StudyTimePage(),
    const PhoneSubmissionPage(),
    const PatrolResultPage(),
    const AttendancePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LifeTabs(
              selectedIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
