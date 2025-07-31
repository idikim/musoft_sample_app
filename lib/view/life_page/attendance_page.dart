import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  void _showScheduleDialog(BuildContext context, DateTime date) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ScheduleDialog(initialDate: date);
      },
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
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

              return GestureDetector(
                onTap: () {
                  if (showDetails) {
                    _showScheduleDialog(context, date);
                  }
                },
                child: Container(
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
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ScheduleDialog extends StatefulWidget {
  final DateTime initialDate;

  const _ScheduleDialog({required this.initialDate});

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  late PageController _pageController;
  static const int _initialPage = 1000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          height: 600,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              final date = widget.initialDate.add(
                Duration(days: index - _initialPage),
              );
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                    value = (1 - (value * 0.1)).clamp(1, 1.0);
                  }
                  return Center(
                    child: Transform.scale(scale: value, child: child),
                  );
                },
                child: _buildDialogContent(date),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(DateTime date) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 580,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 16),
                  child: Text(
                    DateFormat('M월 d일 EEEE', 'ko_KR').format(date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      textAlign: TextAlign.center,
                      '15h 34m',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      textAlign: TextAlign.center,
                      '등원 08:09',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      textAlign: TextAlign.center,
                      '하원 22:01',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final isEntry = index % 2 == 0;
                  return Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${DateFormat('a', 'ko_KR').format(DateTime(0, 0, 0, 9 + index))}\n${DateFormat('hh:mm').format(DateTime(0, 0, 0, 9 + index))}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isEntry
                                    ? Colors.blue.shade100
                                    : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(isEntry ? '입실' : '퇴실'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
