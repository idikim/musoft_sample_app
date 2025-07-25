import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_page.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/item_submission_list.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/sample_penalty_reasons.dart';

class SubmissionListPage extends ConsumerWidget {
  const SubmissionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penaltyReasonsAsyncValue = ref.watch(penaltyReasonsProvider);

    return Scaffold(
      body: Column(
        children: [
          penaltyReasonsAsyncValue.when(
            data: (penaltyReasons) {
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
                return Expanded(
                  child: ItemSubmissionList(
                    penaltyReasons: samplePenaltyReasons,
                  ),
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('오류 발생: $error')),
          ),
        ],
      ),
    );
  }
}
