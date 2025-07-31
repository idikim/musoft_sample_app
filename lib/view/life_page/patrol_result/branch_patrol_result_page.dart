import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BranchPatrolResultPage extends StatefulWidget {
  const BranchPatrolResultPage({super.key});

  @override
  State<BranchPatrolResultPage> createState() => _BranchPatrolResultPageState();
}

class _BranchPatrolResultPageState extends State<BranchPatrolResultPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘의 순찰결과',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(DateFormat('M월 d일').format(selectedDate)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(8),
              color: Colors.black12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: Colors.grey.shade400,
                    child: const Text('강남점'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: const Text('전체지점'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('전체 132명중'),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('졸음 5명'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('학습방해 0명'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('학습무관 1명'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('졸음'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('학습방해'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('학습무관'),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 12,
              children: List.generate(
                10,
                (index) => Column(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      color: Colors.black,
                      child: const Text(
                        '3명',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 40,
                      child: BarChart(
                        BarChartData(
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: 5,
                                  color: Colors.purple,
                                  width: 8,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: 1,
                                  color: Colors.pink,
                                  width: 8,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: 2,
                                  color: Colors.brown,
                                  width: 8,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            ),
                          ],
                          titlesData: FlTitlesData(
                            show: false,
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                    Text('$index교시'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
