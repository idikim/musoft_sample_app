import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/steps/penalty_submission_step1_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/steps/penalty_submission_step2_page.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/steps/penalty_submission_step3_page.dart';
import 'package:madezone_study_student_app/provider/navigation_providers.dart';

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
    int initialPageIndex = 0;
    if (widget.penalty != null && widget.penalty!.isReasonSubmitted) {
      initialPageIndex = 2;
    }
    _pageController = PageController(initialPage: initialPageIndex);
    Future.microtask(() {
      ref.read(currentPageIndexProvider.notifier).state = initialPageIndex;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextStep1(BuildContext context) {
    final selectedReason = ref.read(selectedReasonProvider);
    final reasonInput = ref.read(reasonInputProvider);

    bool isValid = true;

    if (selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '사유를 선택해주세요.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
      isValid = false;
    }

    if (reasonInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '벌점 사유를 입력해주세요.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
      isValid = false;
    }

    if (isValid) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      ref.read(currentPageIndexProvider.notifier).state = 1;
    }
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
        } else if (currentPageIndex == 2) {
          Navigator.of(context).pop();
          return false;
        }
        ref.read(penaltySubmissionLogicProvider).resetSubmissionData();
        return true;
      },
      child: Scaffold(
        appBar:
            currentPageIndex < 2
                ? AppBar(title: const Text('사유 제출'), centerTitle: true)
                : null,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentPageIndex < 2)
                  _StepIndicatorBar(currentPageIndex: currentPageIndex),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height -
                      (currentPageIndex < 2
                          ? AppBar().preferredSize.height
                          : 0) -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      (currentPageIndex < 2 ? 170 : 95),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      ref.read(currentPageIndexProvider.notifier).state = index;
                    },
                    children: [
                      PenaltySubmissionStep1Page(penalty: widget.penalty),
                      const PenaltySubmissionStep2Page(),
                      const PenaltySubmissionStep3Page(),
                    ],
                  ),
                ),
                _SubmissionFooter(
                  currentPageIndex: currentPageIndex,
                  onNext: () => _onNextStep1(context),
                  onPrevious: () {
                    if (currentPageIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                    if (currentPageIndex == 0) {
                      ref
                          .read(penaltySubmissionLogicProvider)
                          .resetSubmissionData();
                    }
                  },
                  onSubmit: () {
                    ref
                        .read(penaltySubmissionLogicProvider)
                        .submitPenaltyReason(
                          penalty: widget.penalty,
                          onSuccess: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                            ref.read(currentPageIndexProvider.notifier).state =
                                2;
                          },
                        );
                  },
                  onViewSubmissions: () {
                    ref.read(stackPageIndexProvider.notifier).state = 0;
                    ref.read(homeTopTabIndexProvider.notifier).state = 4;
                    ref.read(penaltyTabIndexProvider.notifier).state = 2;
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    Navigator.of(context).pop();
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

class _SubmissionFooter extends ConsumerWidget {
  final int currentPageIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final VoidCallback onViewSubmissions;
  final VoidCallback onConfirm;

  const _SubmissionFooter({
    required this.currentPageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
    required this.onViewSubmissions,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReason = ref.watch(selectedReasonProvider);
    final reasonInput = ref.watch(reasonInputProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (currentPageIndex < 2)
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
                  border:
                      (selectedReason != null && reasonInput.isNotEmpty)
                          ? Border.all()
                          : Border.all(color: Colors.grey),
                  color:
                      (selectedReason != null && reasonInput.isNotEmpty)
                          ? Colors.black
                          : Colors.grey,
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
          else if (currentPageIndex == 1)
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
                    onTap: onSubmit,
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
            )
          else if (currentPageIndex == 2)
            Column(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: onViewSubmissions,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(border: Border.all()),
                    width: double.infinity,
                    child: Text(
                      '제출 내역보기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.black,
                    ),
                    width: double.infinity,
                    child: Text(
                      '확인',
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
            ),
        ],
      ),
    );
  }
}
