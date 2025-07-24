import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/penalty_sample_data.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/item_my_penalty.dart'; // Add this line
import 'package:intl/intl.dart';

class MyPenaltyPage extends ConsumerWidget {
  const MyPenaltyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final penalties = getPenaltiesForMonth(selectedMonth);

    final groupedPenalties = _groupPenaltiesByDate(penalties);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<int>(
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
        ),
        Expanded(
          child:
              penalties.isEmpty
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    (penalty) =>
                                        ItemMyPenalty(penalty: penalty),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
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
        penalty.date.year,
        penalty.date.month,
        penalty.date.day,
      );
      if (!groupedPenalties.containsKey(date)) {
        groupedPenalties[date] = [];
      }
      groupedPenalties[date]!.add(penalty);
    }
    return groupedPenalties;
  }
}
