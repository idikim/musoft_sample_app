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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    Text(DateFormat('yyyy-MM-dd').format(penalty.createdAt)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        penalty.status,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '카테고리: ${penalty.category}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('상태: ${penalty.status}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              '사유: ${penalty.description ?? '없음'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '발생 일시: ${DateFormat('yyyy년 MM월 dd일 a hh:mm', 'ko_KR').format(penalty.createdAt)}',
              style: const TextStyle(fontSize: 18),
            ),
            if (penalty.submittedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                '제출 일시: ${DateFormat('yyyy년 MM월 dd일 a hh:mm', 'ko_KR').format(penalty.submittedAt!)}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
            if (penalty.approvalDateTime != null) ...[
              const SizedBox(height: 8),
              Text(
                '승인 일시: ${DateFormat('yyyy년 MM월 dd일 a hh:mm', 'ko_KR').format(penalty.approvalDateTime!)}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
