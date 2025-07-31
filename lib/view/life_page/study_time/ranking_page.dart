import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final ScrollController _scrollController = ScrollController();
  final int _totalCount = 1009; // 4~1012등
  final int _fetchCount = 50;
  int _currentMax = 50;
  String selectedPeriod = '일간';
  String selectedBranch = '강남점';

  final List<String> periodOptions = ['일간', '주간'];
  final List<String> branchOptions = ['강남점', '연수점'];

  late List<Map<String, dynamic>> _rankList;
  int myRank = 68;
  final GlobalKey _myRankKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    double baseHour = 7.2;
    _rankList = List.generate(_totalCount, (i) {
      int rank = i + 4;
      double hour = (baseHour - (rank - 3) * 0.01).clamp(0, baseHour);
      int hours = hour.floor();
      int minutes = ((hour - hours) * 60).round();
      return {
        'rank': rank,
        'name': '이름$rank',
        'branch': rank % 2 == 0 ? '강남점' : '연수점',
        'time': '$hours시간 $minutes분',
      };
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMyRank() {
    if (_currentMax < myRank - 3) {
      setState(() {
        _currentMax =
            ((myRank - 3 + _fetchCount - 1) ~/ _fetchCount) * _fetchCount;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToMyRank());
      return;
    }
    double rowHeight = 64.0;
    double offset = (myRank - 6) * rowHeight;
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 750),
      curve: Curves.ease,
    );
  }

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

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
              ),
              SizedBox(
                height: 320,
                child: Column(
                  children: [
                    Text(
                      '오늘의 열공왕',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                            color:
                                                colors[index % colors.length],
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
              Divider(color: Colors.grey.shade300, thickness: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.all(24),
                color: Colors.black,
                child: GestureDetector(
                  onTap: _scrollToMyRank,
                  child: Text(
                    '내 등수 보러가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('전체 1,012명'),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            if (i == _currentMax) {
              if (_currentMax < _totalCount) {
                Future.microtask(() {
                  if (mounted && _currentMax < _totalCount) {
                    setState(() {
                      _currentMax = (_currentMax + _fetchCount).clamp(
                        0,
                        _totalCount,
                      );
                    });
                  }
                });
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final item = _rankList[i];
            if (item['rank'] == myRank) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                child: Container(
                  key: _myRankKey,
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${item['rank']}'),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name']),
                                Text(item['branch']),
                              ],
                            ),
                            Spacer(),
                            Text(item['time']),
                          ],
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '67등과 1분차이!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '1분 더 공부하고 등수를 올려보세요!',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    Text('${item['rank']}'),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(item['name']), Text(item['branch'])],
                    ),
                    Spacer(),
                    Text(item['time']),
                  ],
                ),
              );
            }
          }, childCount: _currentMax + (_currentMax < _totalCount ? 1 : 0)),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}
