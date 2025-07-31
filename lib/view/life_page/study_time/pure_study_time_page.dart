import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';

class PureStudyTimePage extends StatefulWidget {
  const PureStudyTimePage({super.key});

  @override
  State<PureStudyTimePage> createState() => _PureStudyTimePageState();
}

class _PureStudyTimePageState extends State<PureStudyTimePage> {
  bool _isSimilarScheduleEnabled = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> barData = [
      {'label': '메이드님', 'value': 6.5},
      {'label': '강남점 평균', 'value': 8.33},
      {'label': '1등 공부시간', 'value': 18.17},
    ];

    String formatHour(double hour) {
      final int hours = hour.floor();
      final int minutes = ((hour - hours) * 60).round();
      return '$hours시간 $minutes분';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '오늘의 순공부시간',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            Text(
              '6시간 33분',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            Container(
              padding: EdgeInsets.all(4),
              color: Colors.black12,
              width: double.infinity,
              child: Text('강남점 평균보다 2시간 낮습니다 '),
            ),
            Container(
              padding: EdgeInsets.all(4),
              color: Colors.black12,
              width: double.infinity,
              child: Text('30분만 더하면 박노을님을 추월할 수 있어요'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('전체그룹', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: Center(
                    child: Text(
                      '?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20,
                    minY: 0,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipPadding: const EdgeInsets.all(0),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            formatHour(rod.toY),
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= barData.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              fitInside: SideTitleFitInsideData.fromTitleMeta(
                                meta,
                              ),
                              space: 8,
                              meta: meta,
                              child: Text(
                                barData[index]['label'].replaceAll(' ', ''),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups:
                        barData.asMap().entries.map((entry) {
                          final colors = [
                            Colors.blue[200],
                            Colors.red[200],
                            Colors.amber[200],
                          ];
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value['value'],
                                color: colors[entry.key % colors.length],
                                width: 48,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                            showingTooltipIndicators: [0],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '나와 마이스케줄 비슷한 사람 기준 보기',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeTrackColor: Colors.lightBlue,
                      value: _isSimilarScheduleEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isSimilarScheduleEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
