import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/notice.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/view/stack/stack_page.dart';
import 'package:madezone_study_student_app/view/widgets/animated_page_wrapper.dart';
import 'widgets/home_tabs.dart';
import 'main_tab/main_tab_page.dart';
import 'notice_tab/notice_tab_page.dart';
import 'meal_tab/meal_tab_page.dart';
import 'penalty_tab/penalty_tab_page.dart';
import 'advantage_tab/advantage_tab_page.dart';
import 'notice_tab/notice_detail_page.dart';
import 'penalty_tab/my_penalty/penalty_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/provider/navigation_providers.dart';
import 'package:get/get.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _mealTabIndex = 0;
  NoticePost? _selectedNotice;
  bool _isNoticeDetailShown = false;
  bool _isNoticeDetailFullyVisible = false;

  void _onNoticeSelected(NoticePost notice) {
    setState(() {
      _selectedNotice = notice;
      _isNoticeDetailShown = true;
      _isNoticeDetailFullyVisible = true;
    });
  }

  void _onBackFromNoticeDetail() {
    setState(() {
      _isNoticeDetailShown = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _selectedNotice = null;
          _isNoticeDetailFullyVisible = false;
        });
      }
    });
  }

  void _onPenaltySelected(Penalty penalty) {
    Get.to(
      () => PenaltyDetailPage(penalty: penalty),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topTabIndex = ref.watch(homeTopTabIndexProvider);
    final penaltyTabIndex = ref.watch(penaltyTabIndexProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HomeTabs(
                  topTabs: TabStrings.topTabs,
                  topTabIndex: topTabIndex,
                  onTopTabChanged:
                      (i) =>
                          ref.read(homeTopTabIndexProvider.notifier).state = i,
                  onNotificationTap: () {
                    context
                        .findAncestorStateOfType<StackPageState>()
                        ?.showNotificationPage();
                  },
                ),
                Expanded(child: _buildTabPage(topTabIndex, penaltyTabIndex)),
              ],
            ),
            AnimatedPageWrapper(
              isShown: _isNoticeDetailShown,
              isFullyVisible: _isNoticeDetailFullyVisible,
              child:
                  _selectedNotice != null
                      ? NoticeDetailPage(
                        notice: _selectedNotice!,
                        onBack: _onBackFromNoticeDetail,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPage(int topTabIndex, int penaltyTabIndex) {
    switch (topTabIndex) {
      case 0:
        return const HomeTabMainPage();
      case 1:
        return HomeTabNoticePage(onNoticeSelected: _onNoticeSelected);
      case 2:
        return HomeTabMealPage(
          mealTabIndex: _mealTabIndex,
          onMealTabChanged: (i) => setState(() => _mealTabIndex = i),
        );
      case 3:
        return const HomeTabAdvantagePage();
      case 4:
        return HomeTabPenaltyPage(
          onPenaltySelected: _onPenaltySelected,
          onSubmissionTabSelected: () {
            ref.read(penaltyReasonsRefreshTrigger.notifier).state++;
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
