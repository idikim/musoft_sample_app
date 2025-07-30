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
    final weeklyStudySubjectCount = ref.watch(weeklyStudySubjectCountProvider);
    final mostStudiedSubject = ref.watch(mostStudiedSubjectProvider);

    return Container(
      height: 580,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '학습시간 통계',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주간 총 학습시간',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatMinutes(weeklyTotalMinutes),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$weeklyStudySubjectCount개의 과목',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 240,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '과목별 학습시간',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child:
                        subjectStudyTimes.isEmpty
                            ? Center(
                              child: Text(
                                '이번 주 학습 스케줄이 없습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                            : BarChart(
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
                                        Colors.teal.shade200,
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
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
                                            subjectStudyTimes.keys
                                                .toList()[value.toInt()];
                                        final minutes =
                                            subjectStudyTimes[subject]!;
                                        final hours = minutes ~/ 60;
                                        final remainingMinutes = minutes % 60;

                                        String timeText;
                                        if (hours > 0) {
                                          if (remainingMinutes > 0) {
                                            timeText =
                                                '$hours시간 $remainingMinutes분';
                                          } else {
                                            timeText = '$hours시간';
                                          }
                                        } else {
                                          if (remainingMinutes > 0) {
                                            timeText = '$remainingMinutes분';
                                          } else {
                                            timeText = '';
                                          }
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                timeText,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                subject,
                                                style: TextStyle(fontSize: 10),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      reservedSize: 50,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
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
                                extraLinesData: ExtraLinesData(
                                  horizontalLines: [],
                                ),
                                alignment: BarChartAlignment.spaceAround,
                                maxY:
                                    subjectStudyTimes.values.isEmpty
                                        ? 10
                                        : (subjectStudyTimes.values
                                                .map((e) => e / 60)
                                                .reduce(
                                                  (a, b) => a > b ? a : b,
                                                ) +
                                            1),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '학습패턴',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '평균 일일 학습시간',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatMinutes(averageDailyMinutes),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '가장 많이 공부한 과목',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mostStudiedSubject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
