import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_page.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';

class SubmissionListPage extends ConsumerWidget {
  const SubmissionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penaltyReasonsAsyncValue = ref.watch(penaltyReasonsProvider);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            '벌점 사유가 있으신가요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '제출 후 수정은 불가능하니\n신중하게 작성해주세요',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          Expanded(
            child: penaltyReasonsAsyncValue.when(
              data: (penaltyReasons) {
                return ListView.builder(
                  itemCount: penaltyReasons.length,
                  itemBuilder: (context, index) {
                    final reason = penaltyReasons[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '카테고리: ${reason.category}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text('설명: ${reason.description}'),
                            Text(
                              '시작: ${reason.startDate.toLocal().toString().split(' ')[0]} ${reason.startDate.toLocal().hour}:${reason.startDate.toLocal().minute}',
                            ),
                            Text(
                              '종료: ${reason.endDate.toLocal().toString().split(' ')[0]} ${reason.endDate.toLocal().hour}:${reason.endDate.toLocal().minute}',
                            ),
                            if (reason.imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.file(File(reason.imageUrl!)),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('오류 발생: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
