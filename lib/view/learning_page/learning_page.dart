import 'package:flutter/material.dart';
import 'widgets/learning_tabs.dart';
import 'my_schedule/my_schedule_page.dart';
import 'test/test_page.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['마이스케줄', '테스트'];

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LearningTabs(
              tabs: _tabs,
              selectedTabIndex: _selectedTabIndex,
              onTabChanged: _onTabChanged,
            ),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const MySchedulePage();
      case 1:
        return const TestPage();
      default:
        return const Center();
    }
  }
}
