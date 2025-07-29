import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/penalty_provider.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/calendar/calendar_day_cell.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/my_penalty/penalty_detail_page.dart';

class MyPenaltyCalendarPage extends ConsumerStatefulWidget {
  final DateTime initialMonth;
  final Widget Function(DateTime day)? dayCellBuilder;
  const MyPenaltyCalendarPage({
    super.key,
    required this.initialMonth,
    this.dayCellBuilder,
  });

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
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: daysOfWeek.map((day) => DayOfWeekCell(day: day)).toList(),
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

      if (widget.dayCellBuilder != null) {
        dayCells.add(widget.dayCellBuilder!(day));
      } else {
        dayCells.add(
          CalendarDayCell(
            day: day,
            isCurrentMonth: isCurrentMonth,
            penalties: penalties,
            onPenaltyTap: (penalty) {
              Get.to(
                () => PenaltyDetailPage(penalty: penalty),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          ),
        );
      }
    }

    final int numberOfRows = numberOfWeeks;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellWidth = constraints.maxWidth / 7;
        final double cellHeight = constraints.maxHeight / numberOfRows;
        final double childAspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
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
