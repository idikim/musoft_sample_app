import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';
import 'package:madezone_study_student_app/provider/daily_schedule_provider.dart';

class ScheduleTable extends ConsumerWidget {
  final DateTime selectedDate;
  const ScheduleTable({super.key, required this.selectedDate});

  List<DailySchedule> _schedulesForHour(
    List<DailySchedule> schedules,
    int hour,
    DateTime date,
  ) {
    return schedules.where((s) {
      final start = s.startHour * 60 + s.startMinute;
      final end = s.endHour * 60 + s.endMinute;
      final hStart = hour * 60;
      final hEnd = (hour + 1) * 60;
      return s.date.year == date.year &&
          s.date.month == date.month &&
          s.date.day == date.day &&
          start < hEnd &&
          end > hStart;
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(dailyScheduleForDateProvider(selectedDate));
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: const Text(
                    '시간',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      '스케줄',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int hour = 6; hour <= 23; hour++)
                    _HourRow(
                      hour: hour,
                      schedules: _schedulesForHour(
                        schedules,
                        hour,
                        selectedDate,
                      ),
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

class _HourRow extends StatelessWidget {
  final int hour;
  final List<DailySchedule> schedules;
  const _HourRow({required this.hour, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: null,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('${hour.toString().padLeft(2, '0')}:00'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (schedules.isEmpty) const SizedBox(height: 32),
                  for (final schedule in schedules)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            schedule.category == ScheduleCategory.study
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                schedule.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color:
                                      schedule.category ==
                                              ScheduleCategory.study
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${_formatDuration(schedule.startHour, schedule.startMinute, schedule.endHour, schedule.endMinute)})',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      schedule.category ==
                                              ScheduleCategory.study
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 18,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${schedule.startHour.toString().padLeft(2, '0')}:${schedule.startMinute.toString().padLeft(2, '0')} - ${schedule.endHour.toString().padLeft(2, '0')}:${schedule.endMinute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          if (schedule.details != null)
                            ...schedule.details!.map(
                              (d) => Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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

String _formatDuration(
  int startHour,
  int startMinute,
  int endHour,
  int endMinute,
) {
  final startTotalMinutes = startHour * 60 + startMinute;
  final endTotalMinutes = endHour * 60 + endMinute;
  final durationMinutes = endTotalMinutes - startTotalMinutes;

  if (durationMinutes < 0) return "";

  final hours = durationMinutes ~/ 60;
  final minutes = durationMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return "$hours시간 $minutes분";
  } else if (hours > 0) {
    return "$hours시간";
  } else {
    return "$minutes분";
  }
}
