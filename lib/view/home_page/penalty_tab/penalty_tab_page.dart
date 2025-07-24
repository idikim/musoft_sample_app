import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/navigation_providers.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/widgets/penalty_tab_bar.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/my_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/branch_penalty/branch_penalty_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_list_page.dart';

class HomeTabPenaltyPage extends ConsumerWidget {
  final ValueChanged<Penalty> onPenaltySelected;
  final VoidCallback? onSubmissionTabSelected;
  const HomeTabPenaltyPage({
    super.key,
    required this.onPenaltySelected,
    this.onSubmissionTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penaltyTabIndex = ref.watch(penaltyTabIndexProvider);

    return Column(
      children: [
        PenaltyTabBar(
          penaltyTabIndex: penaltyTabIndex,
          onPenaltyTabChanged: (index) {
            ref.read(penaltyTabIndexProvider.notifier).state = index;
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
