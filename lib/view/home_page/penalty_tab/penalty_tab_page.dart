import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/widgets/penalty_tab_bar.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/my_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/branch_penalty/branch_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_list_page.dart';

class HomeTabPenaltyPage extends StatelessWidget {
  final int penaltyTabIndex;
  final ValueChanged<int> onPenaltyTabChanged;
  final ValueChanged<Penalty> onPenaltySelected;
  final VoidCallback? onSubmissionTabSelected;
  const HomeTabPenaltyPage({
    super.key,
    required this.penaltyTabIndex,
    required this.onPenaltyTabChanged,
    required this.onPenaltySelected,
    this.onSubmissionTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PenaltyTabBar(
          penaltyTabIndex: penaltyTabIndex,
          onPenaltyTabChanged: (index) {
            onPenaltyTabChanged(index);
            if (index == 2) {
              onSubmissionTabSelected?.call();
            }
          },
        ),
        Expanded(
          child: IndexedStack(
            index: penaltyTabIndex,
            children: [
              MyPenaltyPage(onPenaltySelected: onPenaltySelected),
              const BranchPenaltyPage(),
              const SubmissionListPage(),
            ],
          ),
        ),
      ],
    );
  }
}
