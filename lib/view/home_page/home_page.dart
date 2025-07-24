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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _topTabIndex = 0;
  int _mealTabIndex = 0;
  int _penaltyTabIndex = 0;
  Notice? _selectedNotice;
  bool _isNoticeDetailShown = false;
  bool _isNoticeDetailFullyVisible = false;

  Penalty? _selectedPenalty;
  bool _isPenaltyDetailShown = false;
  bool _isPenaltyDetailFullyVisible = false;

  void _onNoticeSelected(Notice notice) {
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
    Future.delayed(AnimatedPageWrapper.pageTransitionDuration, () {
      if (mounted) {
        setState(() {
          _selectedNotice = null;
          _isNoticeDetailFullyVisible = false;
        });
      }
    });
  }

  void _onPenaltySelected(Penalty penalty) {
    setState(() {
      _selectedPenalty = penalty;
      _isPenaltyDetailShown = true;
      _isPenaltyDetailFullyVisible = true;
    });
  }

  void _onBackFromPenaltyDetail() {
    setState(() {
      _isPenaltyDetailShown = false;
    });
    Future.delayed(AnimatedPageWrapper.pageTransitionDuration, () {
      if (mounted) {
        setState(() {
          _selectedPenalty = null;
          _isPenaltyDetailFullyVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HomeTabs(
                  topTabs: TabStrings.topTabs,
                  topTabIndex: _topTabIndex,
                  onTopTabChanged: (i) => setState(() => _topTabIndex = i),
                  onNotificationTap: () {
                    context
                        .findAncestorStateOfType<StackPageState>()
                        ?.showNotificationPage();
                  },
                ),
                Expanded(child: _buildTabPage()),
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
            AnimatedPageWrapper(
              isShown: _isPenaltyDetailShown,
              isFullyVisible: _isPenaltyDetailFullyVisible,
              child:
                  _selectedPenalty != null
                      ? PenaltyDetailPage(
                        penalty: _selectedPenalty!,
                        onBack: _onBackFromPenaltyDetail,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPage() {
    switch (_topTabIndex) {
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
          penaltyTabIndex: _penaltyTabIndex,
          onPenaltyTabChanged: (i) => setState(() => _penaltyTabIndex = i),
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
