import 'package:flutter/material.dart';

class StudyTimeTabStrings {
  static const List<String> studyTimeTabs = ['순공시간', '랭킹', '추이'];
}

class StudyTimeTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const StudyTimeTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
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
        children: List.generate(StudyTimeTabStrings.studyTimeTabs.length, (i) {
          return GestureDetector(
            onTap: () => onTabSelected(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    selectedIndex == i ? Colors.blueAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                StudyTimeTabStrings.studyTimeTabs[i],
                style: TextStyle(
                  color: selectedIndex == i ? Colors.white : Colors.black,
                  fontWeight:
                      selectedIndex == i ? FontWeight.bold : FontWeight.normal,
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
