import 'package:flutter/material.dart';
import 'widgets/notification_dialog.dart';
import 'widgets/home_tabs.dart';
import 'main_tab/main_tab_page.dart';
import 'notice_tab/notice_tab_page.dart';
import 'meal_tab/meal_tab_page.dart';
import 'penalty_tab/penalty_tab_page.dart';
import 'advantage_tab/advantage_tab_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MainViewState();
}

class _MainViewState extends State<HomePage> {
  int _topTabIndex = 2;
  int _mealTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeTabs(
              topTabs: TabStrings.topTabs,
              topTabIndex: _topTabIndex,
              onTopTabChanged: (i) => setState(() => _topTabIndex = i),
              onNotificationTap: () => showNotificationDialog(context),
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
