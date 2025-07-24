import 'package:flutter/material.dart';

class PenaltySubmissionStep2Page extends StatelessWidget {
  const PenaltySubmissionStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '파일 제출하기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '파일은 최대 3개까지 업로드 할 수 있습니다.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('제출 목록 0', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '추가하기',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.black12,
          child: Center(child: Text('업로드된 파일이 없습니다')),
        ),
      ],
    );
  }
}
