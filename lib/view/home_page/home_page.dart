import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/stack/stack_page.dart';
import 'widgets/home_tabs.dart';
import 'main_tab/main_tab_page.dart';
import 'notice_tab/notice_tab_page.dart';
import 'meal_tab/meal_tab_page.dart';
import 'penalty_tab/penalty_tab_page.dart';
import 'advantage_tab/advantage_tab_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _topTabIndex = 0;
  int _mealTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
      ),
    );
  }

  Widget _buildTabPage() {
    switch (_topTabIndex) {
      case 0:
        return const HomeTabMainPage();
      case 1:
        return const HomeTabNoticePage();
      case 2:
        return HomeTabMealPage(
          mealTabIndex: _mealTabIndex,
          onMealTabChanged: (i) => setState(() => _mealTabIndex = i),
        );
      case 3:
        return const HomeTabAdvantagePage();
      case 4:
        return const HomeTabPenaltyPage();
      default:
        return const SizedBox.shrink();
    }
  }
}
