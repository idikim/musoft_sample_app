import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeTabMainPage extends StatelessWidget {
  const HomeTabMainPage({super.key});

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

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '모의고사 테스트 등급제 안내',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('한줄 설명 입력', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.black12,
                  child: Icon(Icons.image, size: 32, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  '메이드님의 순공시간',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '6시간 30분',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '광진점에서 30명 중 22위',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
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
                      getTooltipColor: (group) => Colors.white,
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
          const SizedBox(height: 12),
          const _InfoCard(
            title: '오늘 받은 벌점 2점 (총 4점)',
            content: Row(
              children: [
                Icon(Icons.warning_rounded, size: 18, color: Colors.amber),
                SizedBox(width: 4),
                Text('이번 달은 벌점 주의가 필요합니다', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const _InfoCard(
            title: '오늘 예정된 상담 (2건)',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CounselInfoRow(time: '14:20', subject: '학사일정'),
                SizedBox(height: 4),
                _CounselInfoRow(time: '16:00', subject: '진로상담'),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget content;

  const _InfoCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                content,
              ],
            ),
            Row(
              children: const [
                Text('상세보기', style: TextStyle(fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CounselInfoRow extends StatelessWidget {
  final String time;
  final String subject;

  const _CounselInfoRow({required this.time, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(subject, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
