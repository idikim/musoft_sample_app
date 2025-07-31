import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/calendar/my_penalty_calendar_page.dart';
import 'package:madezone_study_student_app/view/learning_page/my_schedule/widgets/date_picker_bottom_sheet.dart';

class AttendancePage extends ConsumerWidget {
  const AttendancePage({super.key});

  void _showDatePickerBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DatePickerBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final selectedYear = ref.watch(selectedYearProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(isDatePickerOpenProvider.notifier).state = true;
                  _showDatePickerBottomSheet(context, ref);
                },
                child: Row(
                  children: [
                    Text(
                      '$selectedMonth월',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: MyPenaltyCalendarPage(
            initialMonth: DateTime(selectedYear, selectedMonth),
            dayCellBuilder: (date) {
              final isCurrentMonth = date.month == selectedMonth;
              final showDetails =
                  isCurrentMonth && date.day >= 1 && date.day <= 22;

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isCurrentMonth ? Colors.black : Colors.black26,
                        ),
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 4),
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: const Center(
                          child: Text(
                            '15h 34m',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '등원 08:09',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        '하원 22:01',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
