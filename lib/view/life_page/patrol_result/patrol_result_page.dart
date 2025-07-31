import 'package:flutter/material.dart';
import '../widgets/patrol_result_tabs.dart';
import 'my_patrol_result_page.dart';
import 'branch_patrol_result_page.dart';

class PatrolResultPage extends StatefulWidget {
  const PatrolResultPage({super.key});

  @override
  State<PatrolResultPage> createState() => _PatrolResultPageState();
}

class _PatrolResultPageState extends State<PatrolResultPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyPatrolResultPage(),
    const BranchPatrolResultPage(),
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
        PatrolResultTabs(
          selectedIndex: _selectedIndex,
          onTabSelected: _onTabSelected,
        ),
        Expanded(child: _pages[_selectedIndex]),
      ],
    );
  }
}
