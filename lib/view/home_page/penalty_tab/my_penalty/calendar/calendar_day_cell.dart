import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'penalty_card.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final bool isCurrentMonth;
  final List<Penalty> penalties;
  final void Function(Penalty) onPenaltyTap;
  const CalendarDayCell({
    required this.day,
    required this.isCurrentMonth,
    required this.penalties,
    required this.onPenaltyTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                fontSize: 12,
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
                            (penalty) => PenaltyCard(
                              penalty: penalty,
                              onTap: () => onPenaltyTap(penalty),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DayOfWeekCell extends StatelessWidget {
  final String day;
  const DayOfWeekCell({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          ' $day요일',
          style: TextStyle(
            fontSize: 12,
            color: day == '일' ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
