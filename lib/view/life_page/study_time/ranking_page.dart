import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String selectedPeriod = '일간';
  String selectedBranch = '강남점';

  final List<String> periodOptions = ['일간', '주간'];
  final List<String> branchOptions = ['강남점', '연수점'];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> barData = [
      {
        'label': '김이등님',
        'value': 8.5,
        'trophy': 'assets/images/svg/trophy2.svg',
      },
      {
        'label': '메이드님',
        'value': 12.3,
        'trophy': 'assets/images/svg/trophy1.svg',
      },
      {
        'label': '박삼등님',
        'value': 7.2,
        'trophy': 'assets/images/svg/trophy2.svg',
      },
    ];

    String formatHour(double hour) {
      final int hours = hour.floor();
      final int minutes = ((hour - hours) * 60).round();
      return '$hours시간 $minutes분';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  underline: SizedBox(),
                  items:
                      periodOptions.map((String period) {
                        return DropdownMenuItem<String>(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedBranch,
                  underline: SizedBox(),
                  items:
                      branchOptions.map((String branch) {
                        return DropdownMenuItem<String>(
                          value: branch,
                          child: Text(branch),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBranch = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Text(
                  '오늘의 열공왕',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '하루 공부시간 기준 TOP 랭킹',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 15,
                            minY: 0,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.transparent,
                                tooltipPadding: const EdgeInsets.all(0),
                                tooltipMargin: -30,
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  final index = group.x.toInt();
                                  final label = barData[index]['label'];
                                  return BarTooltipItem(
                                    '',
                                    const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: label,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const TextSpan(text: '\n\n'),
                                      TextSpan(
                                        text: formatHour(rod.toY),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
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
                                        color:
                                            colors[entry.key % colors.length],
                                        width: 80,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
