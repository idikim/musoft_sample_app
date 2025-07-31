import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/counsel_page/counsel_log_page.dart';
import 'package:madezone_study_student_app/view/counsel_page/offline_qa/offline_qa_page.dart';
import 'package:madezone_study_student_app/view/counsel_page/online_qa_page.dart';
import 'package:madezone_study_student_app/view/counsel_page/widgets/counsel_tabs.dart';

class CounselPage extends StatefulWidget {
  const CounselPage({super.key});

  @override
  State<CounselPage> createState() => _CounselPageState();
}

class _CounselPageState extends State<CounselPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CounselTabs(
              selectedIndex: _selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  CounselLogPage(),
                  OfflineQAPage(),
                  OnlineQAPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
