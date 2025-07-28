import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';
import 'package:madezone_study_student_app/provider/penalty_provider.dart'
    as pp;
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_page.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/item_submission_list.dart';

class SubmissionListPage extends ConsumerWidget {
  final Function(Penalty) onPenaltySelected;

  const SubmissionListPage({super.key, required this.onPenaltySelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPenalties = ref.watch(pp.penaltiesProvider);

    return Scaffold(
      body: Column(
        children: [
          Builder(
            builder: (context) {
              final penaltyReasons = ref.watch(pp.penaltyReasonsProvider);
              if (penaltyReasons.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: 60),
                    Text(
                      '벌점 사유가 있으신가요?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '제출 후 수정은 불가능하니\n신중하게 작성해주세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const SubmissionPage(),
                          ),
                        );
                        ref.read(penaltyReasonsRefreshTrigger.notifier).state++;
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        color: Colors.black,
                        child: Text(
                          '사유 작성하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final reasonsWithDescriptions =
                    penaltyReasons.map((reason) {
                      allPenalties.firstWhere(
                        (penalty) => penalty.id == reason.penaltyId,
                        orElse:
                            () => Penalty(
                              id: reason.id,
                              points: 0,
                              category: reason.category,
                              createdAt: DateTime.now(),
                            ),
                      );
                      return PenaltyReason(
                        id: reason.id,
                        category: reason.category,
                        penaltyId: reason.penaltyId,
                        startDate: reason.startDate,
                        endDate: reason.endDate,
                        imageUrls: reason.imageUrls,
                        userReason: reason.userReason,
                        submittedAt: reason.submittedAt,
                      );
                    }).toList();

                reasonsWithDescriptions.sort((a, b) {
                  final penaltyA = allPenalties.firstWhere(
                    (penalty) => penalty.id == a.penaltyId,
                    orElse:
                        () => Penalty(
                          id: a.penaltyId,
                          points: 0,
                          category: a.category,
                          createdAt: DateTime.now(),
                        ),
                  );
                  final penaltyB = allPenalties.firstWhere(
                    (penalty) => penalty.id == b.penaltyId,
                    orElse:
                        () => Penalty(
                          id: b.penaltyId,
                          points: 0,
                          category: b.category,
                          createdAt: DateTime.now(),
                        ),
                  );
                  return penaltyA.createdAt.compareTo(penaltyB.createdAt);
                });

                return Expanded(
                  child: ItemSubmissionList(
                    penaltyReasons: reasonsWithDescriptions,
                    onPenaltySelected: onPenaltySelected,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
