import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  String selectedPeriod = '주간';

  final List<String> periodOptions = ['일간', '주간'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          '지난주에 공부한 평균 시간',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '98시간 20분',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text(
                          '일주일간 기록한 공부 시간의 일별 평균',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_left_rounded),
                      Text('07월 06일 ~ 07일 12일 '),
                      Icon(Icons.arrow_right_rounded),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(8),
                      color: Colors.black12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            color: Colors.grey.shade400,
                            child: Text('강남점'),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text('전체지점'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,

                    padding: EdgeInsets.all(16),

                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}h',
                                  style: TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  '7/6',
                                  '7/7',
                                  '7/8',
                                  '7/9',
                                  '7/10',
                                  '7/11',
                                  '7/12',
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < days.length) {
                                  return Text(
                                    days[value.toInt()],
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 0,
                        maxY: 12,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 2),
                              FlSpot(1, 4),
                              FlSpot(2, 6),
                              FlSpot(3, 8),
                              FlSpot(4, 7),
                              FlSpot(5, 10),
                              FlSpot(6, 6),
                            ],
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.withOpacity(0.4),
                                  Colors.red.withOpacity(0.05),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
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
