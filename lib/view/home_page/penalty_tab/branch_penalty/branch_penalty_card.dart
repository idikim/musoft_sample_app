import 'package:flutter/material.dart';

class BranchPenaltyCard extends StatelessWidget {
  final String penaltyPoints;
  final String numberOfStudents;
  final IconData topIcon;
  final Color topIconColor;
  final IconData bottomIcon;
  final String bottomText;
  final Color bottomTextColor;

  const BranchPenaltyCard({
    super.key,
    required this.penaltyPoints,
    required this.numberOfStudents,
    required this.topIcon,
    required this.topIconColor,
    required this.bottomIcon,
    required this.bottomText,
    required this.bottomTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        spacing: 12,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            height: 102,
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '벌점 $penaltyPoints',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text('$numberOfStudents명'),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Icon(topIcon, color: topIconColor)],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            width: 102,
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                Icon(bottomIcon),
                Text('내가 속한 곳은 여기', style: TextStyle(fontSize: 8)),
                Text(
                  bottomText,
                  style: TextStyle(
                    color: bottomTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
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
