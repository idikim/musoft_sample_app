import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/counsel_page/offline_qa/qa_history_page.dart';
import 'package:madezone_study_student_app/view/counsel_page/offline_qa/qa_reservation_page.dart';
import 'package:madezone_study_student_app/view/counsel_page/offline_qa/widgets/offline_qa_tab_bar.dart';

class OfflineQAPage extends StatefulWidget {
  const OfflineQAPage({super.key});

  @override
  State<OfflineQAPage> createState() => _OfflineQAPageState();
}

class _OfflineQAPageState extends State<OfflineQAPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OfflineQATabBar(
          tabIndex: _tabIndex,
          onTabChanged: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
        Expanded(
          child: IndexedStack(
            index: _tabIndex,
            children: const [QAReservationPage(), QAHistoryPage()],
          ),
        ),
      ],
    );
  }
}
