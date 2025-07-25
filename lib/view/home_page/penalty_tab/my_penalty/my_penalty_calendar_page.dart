import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/my_penalty_page.dart'; // Import MyPenaltyPage to access penaltiesProvider

class MyPenaltyCalendarPage extends ConsumerStatefulWidget {
  final DateTime initialMonth;
  const MyPenaltyCalendarPage({super.key, required this.initialMonth});

  @override
  ConsumerState<MyPenaltyCalendarPage> createState() =>
      _MyPenaltyCalendarPageState();
}

class _MyPenaltyCalendarPageState extends ConsumerState<MyPenaltyCalendarPage> {
  late DateTime _focusedDay;
  final Map<DateTime, List<Penalty>> _penaltyData = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialMonth;
  }

  @override
  void didUpdateWidget(covariant MyPenaltyCalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth.month != oldWidget.initialMonth.month ||
        widget.initialMonth.year != oldWidget.initialMonth.year) {
      setState(() {
        _focusedDay = widget.initialMonth;
      });
    }
  }

  void _loadPenalties(List<Penalty> allPenalties) {
    _penaltyData.clear();
    final penalties =
        allPenalties
            .where((p) => p.createdAt.month == _focusedDay.month)
            .toList();
    for (var penalty in penalties) {
      final normalizedDate = _normalizeDate(penalty.createdAt);
      if (_penaltyData.containsKey(normalizedDate)) {
        _penaltyData[normalizedDate]!.add(penalty);
      } else {
        _penaltyData[normalizedDate] = [penalty];
      }
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int _daysInMonth(int year, int month) {
    if (month == DateTime.february) {
      return _isLeapYear(year) ? 29 : 28;
    } else if (month == DateTime.april ||
        month == DateTime.june ||
        month == DateTime.september ||
        month == DateTime.november) {
      return 30;
    } else {
      return 31;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allPenalties = ref.watch(penaltiesProvider);
    _loadPenalties(allPenalties);

    return Column(
      children: [
        _buildDaysOfWeekHeader(),
        Expanded(child: _buildCalendarGrid()),
      ],
    );
  }

  Widget _buildDaysOfWeekHeader() {
    final List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    return Container(
      decoration: BoxDecoration(color: Colors.black12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children:
              daysOfWeek.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      '$day요일',
                      style: TextStyle(
                        fontSize: 10,
                        color: day == '일' ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final DateTime firstDayOfCurrentMonth = DateTime(
      _focusedDay.year,
      _focusedDay.month,
      1,
    );
    final int daysToSubtract = firstDayOfCurrentMonth.weekday % 7;
    final DateTime startDay = firstDayOfCurrentMonth.subtract(
      Duration(days: daysToSubtract),
    );

    final int totalDaysInMonth = _daysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );
    final int numberOfWeeks = ((totalDaysInMonth + daysToSubtract) / 7).ceil();
    final int totalCells = numberOfWeeks * 7;

    List<Widget> dayCells = [];

    for (int i = 0; i < totalCells; i++) {
      final DateTime day = startDay.add(Duration(days: i));
      final bool isCurrentMonth = day.month == _focusedDay.month;
      final List<Penalty> penalties = _penaltyData[_normalizeDate(day)] ?? [];

      dayCells.add(
        GestureDetector(
          onTap: () {
            print('Tapped on ${day.toIso8601String()}');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isCurrentMonth
                              ? (day.weekday == DateTime.sunday
                                  ? Colors.red
                                  : Colors.black)
                              : Colors.black26,
                    ),
                  ),
                ),
                if (penalties.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            penalties
                                .map(
                                  (penalty) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    width: double.infinity,
                                    color: Colors.red.shade50,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '-${penalty.points}점',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              penalty.category.displayName,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final int numberOfRows = numberOfWeeks;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellWidth = constraints.maxWidth / 7;
        final double cellHeight = constraints.maxHeight / numberOfRows;
        final double childAspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: dayCells.length,
          itemBuilder: (context, index) {
            return dayCells[index];
          },
        );
      },
    );
  }
}
