import 'package:flutter/material.dart';

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
      {'label': '김이등님', 'value': 8.5, 'trophy': 'assets/images/trophy2.png'},
      {'label': '메이드님', 'value': 12.3, 'trophy': 'assets/images/trophy1.png'},
      {'label': '박삼등님', 'value': 7.2, 'trophy': 'assets/images/trophy2.png'},
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    final double barAreaWidth = screenWidth - 40;
    final int barCount = barData.length;
    final double barWidth = (barAreaWidth / (barCount * 1.3)).clamp(
      40.0,
      100.0,
    );

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
                  height: 220,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(barData.length, (index) {
                            final item = barData[index];
                            final double value = item['value'];
                            final double barHeight = (value / 15) * 150;
                            final colors = [
                              Colors.blue[200],
                              Colors.red[200],
                              Colors.amber[200],
                            ];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 52,
                                  child: Image.asset(
                                    item['trophy'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['label'],
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 4),
                                      width: barWidth,
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        color: colors[index % colors.length],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        formatHour(value),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
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
