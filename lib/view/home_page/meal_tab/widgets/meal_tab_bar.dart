import 'package:flutter/material.dart';

class MealTabStrings {
  static const List<String> mealTabs = ['신청하기', '신청현황'];
}

class HomeTabMealTabBar extends StatelessWidget {
  final int mealTabIndex;
  final ValueChanged<int> onMealTabChanged;
  const HomeTabMealTabBar({
    super.key,
    required this.mealTabIndex,
    required this.onMealTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(MealTabStrings.mealTabs.length, (i) {
          return GestureDetector(
            onTap: () => onMealTabChanged(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    mealTabIndex == i ? Colors.blue[100] : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                MealTabStrings.mealTabs[i],
                style: TextStyle(
                  color: mealTabIndex == i ? Colors.blue : Colors.black,
                  fontWeight:
                      mealTabIndex == i ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
