import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/widgets/penalty_tab_bar.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/my_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/branch_penalty/branch_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/reason_submission/reason_submission_page.dart';

class HomeTabPenaltyPage extends StatelessWidget {
  final int penaltyTabIndex;
  final ValueChanged<int> onPenaltyTabChanged;
  const HomeTabPenaltyPage({
    super.key,
    required this.penaltyTabIndex,
    required this.onPenaltyTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PenaltyTabBar(
          penaltyTabIndex: penaltyTabIndex,
          onPenaltyTabChanged: onPenaltyTabChanged,
        ),
        Expanded(
          child: IndexedStack(
            index: penaltyTabIndex,
            children: const [
              MyPenaltyPage(),
              BranchPenaltyPage(),
              ReasonSubmissionPage(),
            ],
          ),
        ),
      ],
    );
  }
}
