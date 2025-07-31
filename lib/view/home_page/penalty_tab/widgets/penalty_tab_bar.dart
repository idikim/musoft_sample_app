import 'package:flutter/material.dart';

class PenaltyTabStrings {
  static const List<String> penaltyTabs = ['나의 벌점', '지점별 내역', '사유 제출'];
}

class PenaltyTabBar extends StatelessWidget {
  final int penaltyTabIndex;
  final ValueChanged<int> onPenaltyTabChanged;
  const PenaltyTabBar({
    super.key,
    required this.penaltyTabIndex,
    required this.onPenaltyTabChanged,
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
        children: List.generate(PenaltyTabStrings.penaltyTabs.length, (i) {
          return GestureDetector(
            onTap: () => onPenaltyTabChanged(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    penaltyTabIndex == i
                        ? Colors.blueAccent
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                PenaltyTabStrings.penaltyTabs[i],
                style: TextStyle(
                  color: penaltyTabIndex == i ? Colors.white : Colors.black,
                  fontWeight:
                      penaltyTabIndex == i
                          ? FontWeight.bold
                          : FontWeight.normal,
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
