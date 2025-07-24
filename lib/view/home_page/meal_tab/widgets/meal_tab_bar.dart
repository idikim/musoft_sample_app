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
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(MealTabStrings.mealTabs.length, (i) {
          return GestureDetector(
            onTap: () => onMealTabChanged(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    mealTabIndex == i ? Colors.blueAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                MealTabStrings.mealTabs[i],
                style: TextStyle(
                  color: mealTabIndex == i ? Colors.white : Colors.black,
                  fontWeight:
                      mealTabIndex == i ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
