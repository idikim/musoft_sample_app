import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:madezone_study_student_app/provider/study_time_provider.dart';

class StudyTimeStatisticsBottomSheet extends ConsumerWidget {
  const StudyTimeStatisticsBottomSheet({super.key});

  String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) {
      return '$h시간 $m분';
    } else {
      return '$m분';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyTotalMinutes = ref.watch(weeklyStudyTimeProvider);
    final averageDailyMinutes = ref.watch(averageDailyStudyTimeProvider);
    final subjectStudyTimes = ref.watch(subjectStudyTimeProvider);

    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '학습시간 통계',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '주간 총 학습시간: ${_formatMinutes(weeklyTotalMinutes)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주간 과목별 학습시간',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        barGroups:
                            subjectStudyTimes.entries.map((entry) {
                              final subject = entry.key;
                              final minutes = entry.value;
                              final index = subjectStudyTimes.keys
                                  .toList()
                                  .indexOf(subject);
                              final List<Color> pastelColors = [
                                Colors.blue.shade200,
                                Colors.green.shade200,
                                Colors.orange.shade200,
                                Colors.purple.shade200,
                                Colors.pink.shade200,
                              ];
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: minutes / 60,
                                    color:
                                        pastelColors[index %
                                            pastelColors.length],
                                    width: 16,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }).toList(),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final subject =
                                    subjectStudyTimes.keys.toList()[value
                                        .toInt()];
                                return Text(
                                  subject,
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 20,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}h',
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 28,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '평균 일일 학습시간: ${_formatMinutes(averageDailyMinutes)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
