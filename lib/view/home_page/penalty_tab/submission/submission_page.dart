import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/penalty_submission_step1_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/penalty_submission_step2_page.dart';

final currentPageIndexProvider = StateProvider<int>((ref) => 0);

class SubmissionPage extends ConsumerStatefulWidget {
  final Penalty? penalty;
  const SubmissionPage({super.key, this.penalty});

  @override
  ConsumerState<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends ConsumerState<SubmissionPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: ref.read(currentPageIndexProvider),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(currentPageIndexProvider);

    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex == 1) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('사유 제출'), centerTitle: true),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepIndicatorBar(currentPageIndex: currentPageIndex),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      ref.read(currentPageIndexProvider.notifier).state = index;
                    },
                    children: [
                      PenaltySubmissionStep1Page(penalty: widget.penalty),
                      const PenaltySubmissionStep2Page(),
                    ],
                  ),
                ),
                _SubmissionFooter(
                  currentPageIndex: currentPageIndex,
                  onNext: () {
                    if (currentPageIndex < 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  onPrevious: () {
                    if (currentPageIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIndicatorBar extends StatelessWidget {
  final int currentPageIndex;
  const _StepIndicatorBar({required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: _StepIndicator(
            text: '1단계 사유작성',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ),
        Expanded(
          child: _StepIndicator(
            text: '2단계 파일 업로드',
            backgroundColor:
                currentPageIndex == 1 ? Colors.red : Colors.black26,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StepIndicator({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SubmissionFooter extends StatelessWidget {
  final int currentPageIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _SubmissionFooter({
    required this.currentPageIndex,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            '* 제출 시 부모님께 알림톡이 전송되며, 승인이 완료 되어야 합니다.',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          if (currentPageIndex == 0)
            GestureDetector(
              onTap: onNext,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.black,
                ),
                width: double.infinity,
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Row(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: onPrevious,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(
                      '이전',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.black,
                      ),

                      child: Text(
                        '제출하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
