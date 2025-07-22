import 'package:flutter/material.dart';
import 'package:musoft_sample_app/view/home_page/meal_tab/widgets/meal_tab_bar.dart';
import 'apply_page/meal_apply_page.dart';
import 'status_page/meal_status_page.dart';

class HomeTabMealPage extends StatelessWidget {
  final int mealTabIndex;
  final ValueChanged<int> onMealTabChanged;
  const HomeTabMealPage({
    super.key,
    required this.mealTabIndex,
    required this.onMealTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeTabMealTabBar(
          mealTabIndex: mealTabIndex,
          onMealTabChanged: onMealTabChanged,
        ),
        Expanded(
          child:
              mealTabIndex == 0
                  ? const MealApplyPage()
                  : const MealStatusPage(),
        ),
      ],
    );
  }
}
