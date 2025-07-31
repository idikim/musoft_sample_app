import 'package:flutter/material.dart';

class PatrolResultTabStrings {
  static const List<String> patrolResultTabs = ['나의 순찰 결과', '지점별 순찰 결과'];
}

class PatrolResultTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const PatrolResultTabs({
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
        children: List.generate(
          PatrolResultTabStrings.patrolResultTabs.length,
          (i) {
            return GestureDetector(
              onTap: () => onTabSelected(i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      selectedIndex == i
                          ? Colors.blueAccent
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  PatrolResultTabStrings.patrolResultTabs[i],
                  style: TextStyle(
                    color: selectedIndex == i ? Colors.white : Colors.black,
                    fontWeight:
                        selectedIndex == i
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
