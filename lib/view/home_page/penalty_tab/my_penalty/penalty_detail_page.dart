import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty.dart';

class PenaltyDetailPage extends StatelessWidget {
  final Penalty penalty;
  final VoidCallback onBack;

  const PenaltyDetailPage({
    super.key,
    required this.penalty,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사유 제출 내역 상세보기'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(penalty.createdAt)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(),
                          ),
                          child: Text(
                            penalty.category,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          '-${penalty.points}점',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          spacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    penalty.status == null
                                        ? Border.fromBorderSide(BorderSide.none)
                                        : Border.all(),
                              ),
                              child: Text(
                                penalty.status ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Text(
                              penalty.approvalDateTime != null
                                  ? DateFormat(
                                    'a hh:mm',
                                    'ko_KR',
                                  ).format(penalty.approvalDateTime!)
                                  : '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Text('사유: ${penalty.description}'),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300], thickness: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('날짜'),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(
                    DateFormat(
                      'yyyy-MM-dd E요일',
                      'ko_KR',
                    ).format(penalty.createdAt),
                  ),
                ),
                Text('시간'),
                Row(
                  spacing: 12,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        DateFormat('HH:mm').format(penalty.createdAt),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        DateFormat('HH:mm').format(penalty.createdAt),
                      ),
                    ),
                    Text('N시간 N분'),
                  ],
                ),
                Text('내가 제출한 사유'),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Text('집에 급한 일이 생겨서 오늘은 조퇴하겠습니다!'),
                ),
                Text('첨부파일'),
                Row(
                  spacing: 8,
                  children: [attachedImage(context), attachedImage(context)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget attachedImage(context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '첨부파일',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('dock2025078060000.jpeg'),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[500],
                        size: 50,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            '닫기',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.black12,
        child: Icon(Icons.photo, color: Colors.grey),
      ),
    );
  }
}
