import 'package:flutter/material.dart';
import '../widgets/study_time_tabs.dart';
import 'pure_study_time_page.dart';
import 'ranking_page.dart';
import 'trend_page.dart';

class StudyTimePage extends StatefulWidget {
  const StudyTimePage({super.key});

  @override
  State<StudyTimePage> createState() => _StudyTimePageState();
}

class _StudyTimePageState extends State<StudyTimePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PureStudyTimePage(),
    const RankingPage(),
    const TrendPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StudyTimeTabs(
          selectedIndex: _selectedIndex,
          onTabSelected: _onTabSelected,
        ),
        Expanded(child: _pages[_selectedIndex]),
      ],
    );
  }
}
