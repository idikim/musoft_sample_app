import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/learning_page/widgets/study_time_statistics_bottom_sheet.dart';

class LearningTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;

  const LearningTabs({
    super.key,
    required this.tabs,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ...List.generate(tabs.length, (i) {
                  return GestureDetector(
                    onTap: () => onTabChanged(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border:
                            selectedTabIndex == i
                                ? const Border(
                                  bottom: BorderSide(
                                    width: 2,
                                    color: Colors.blueAccent,
                                  ),
                                )
                                : null,
                      ),
                      child: Text(
                        tabs[i],
                        style: TextStyle(
                          color:
                              selectedTabIndex == i
                                  ? Colors.blueAccent
                                  : Colors.black,
                          fontWeight:
                              selectedTabIndex == i
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (BuildContext context) {
                  return const StudyTimeStatisticsBottomSheet();
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Icon(Icons.bar_chart_rounded),
                  ),
                  const Text(
                    '과목별 통계',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
