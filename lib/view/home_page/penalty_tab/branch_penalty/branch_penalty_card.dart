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
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0;

    return SizedBox(
      width: 102 * scaleFactor,
      child: Column(
        spacing: 12 * scaleFactor,
        children: [
          Container(
            padding: EdgeInsets.all(12 * scaleFactor),
            height: 102 * scaleFactor,
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
                          style: TextStyle(fontSize: 12 * scaleFactor),
                        ),
                        Text(
                          '$numberOfStudents명',
                          style: TextStyle(fontSize: 14 * scaleFactor),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(topIcon, color: topIconColor, size: 24 * scaleFactor),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8 * scaleFactor),
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              spacing: 2,
              children: [
                Icon(bottomIcon, size: 24 * scaleFactor),
                Text(
                  '내가 속한 곳은 여기',
                  style: TextStyle(fontSize: 10 * scaleFactor),
                ),
                Text(
                  bottomText,
                  style: TextStyle(
                    color: bottomTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * scaleFactor,
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
