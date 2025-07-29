import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/schedule_sample.dart';
import 'package:madezone_study_student_app/provider/schedule_sample_provider.dart';

class ScheduleTable extends ConsumerWidget {
  const ScheduleTable({super.key});

  List<ScheduleSample> _schedulesForHour(
    List<ScheduleSample> samples,
    int hour,
  ) {
    return samples.where((s) {
      final start = s.startHour * 60 + s.startMinute;
      final end = s.endHour * 60 + s.endMinute;
      final hStart = hour * 60;
      final hEnd = (hour + 1) * 60;
      return start < hEnd && end > hStart;
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final samples = ref.watch(scheduleSampleProvider);
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
                      schedules: _schedulesForHour(samples, hour),
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
  final List<ScheduleSample> schedules;
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
                        color: schedule.color.withOpacity(0.7),
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
                              Icon(
                                Icons.schedule,
                                size: 18,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                schedule.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (schedule.subtitle != null)
                                Text(
                                  schedule.subtitle!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                          if (schedule.details != null)
                            ...schedule.details!.map(
                              (d) => Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 2,
                                ),
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
