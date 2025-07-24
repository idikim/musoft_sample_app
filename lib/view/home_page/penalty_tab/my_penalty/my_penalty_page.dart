import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/penalty_sample_data.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/item_my_penalty.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/my_penalty_calendar_page.dart';

class MyPenaltyPage extends ConsumerWidget {
  final ValueChanged<Penalty> onPenaltySelected;
  const MyPenaltyPage({super.key, required this.onPenaltySelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final penalties = getPenaltiesForMonth(selectedMonth);
    final isListMode = ref.watch(penaltyViewModeProvider);

    final groupedPenalties = _groupPenaltiesByDate(penalties);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<int>(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              iconSize: 30,
              dropdownColor: Colors.white,
              underline: Container(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              value: selectedMonth,
              items: [
                const DropdownMenuItem(value: 0, child: Text('전체')),
                for (int i = 1; i <= 12; i++)
                  DropdownMenuItem(value: i, child: Text('$i월')),
              ],
              onChanged:
                  (month) =>
                      ref.read(selectedMonthProvider.notifier).state = month!,
            ),
            Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: isListMode ? Colors.grey[200] : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    iconSize: 18.0,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.list),
                    onPressed:
                        () =>
                            ref.read(penaltyViewModeProvider.notifier).state =
                                true,
                  ),
                ),
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: !isListMode ? Colors.grey[200] : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    iconSize: 18.0,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.calendar_today),
                    onPressed:
                        () =>
                            ref.read(penaltyViewModeProvider.notifier).state =
                                false,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
        Expanded(
          child:
              isListMode
                  ? penalties.isEmpty
                      ? const Center(
                        child: Text(
                          '벌점 내역이 없습니다.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                groupedPenalties.entries.map((entry) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          DateFormat(
                                            'M월 d일 (E)',
                                            'ko_KR',
                                          ).format(entry.key),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black12,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '벌점 ${entry.value.fold(0, (sum, item) => sum + item.points)}점',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...entry.value.map(
                                        (penalty) => ItemMyPenalty(
                                          penalty: penalty,
                                          onPenaltySelected: onPenaltySelected,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      )
                  : MyPenaltyCalendarPage(
                    initialMonth: DateTime(
                      DateTime.now().year,
                      selectedMonth == 0 ? DateTime.now().month : selectedMonth,
                      1,
                    ),
                  ),
        ),
      ],
    );
  }

  Map<DateTime, List<Penalty>> _groupPenaltiesByDate(List<Penalty> penalties) {
    final Map<DateTime, List<Penalty>> groupedPenalties = {};
    for (var penalty in penalties) {
      final date = DateTime(
        penalty.createdAt.year,
        penalty.createdAt.month,
        penalty.createdAt.day,
      );
      if (!groupedPenalties.containsKey(date)) {
        groupedPenalties[date] = [];
      }
      groupedPenalties[date]!.add(penalty);
    }
    return groupedPenalties;
  }
}
