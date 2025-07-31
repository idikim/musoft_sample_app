import 'package:flutter/material.dart';

class PenaltySubmissionStep3Page extends StatelessWidget {
  const PenaltySubmissionStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline_rounded, size: 80),
        SizedBox(height: 20),
        Text(
          '제출을 완료했습니다',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '부모님께 알림톡이 전송되었습니다',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
