import 'dart:io';
import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';

class ItemSubmissionList extends StatelessWidget {
  final List<PenaltyReason> penaltyReasons;

  const ItemSubmissionList({super.key, required this.penaltyReasons});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: penaltyReasons.length,
      itemBuilder: (context, index) {
        final reason = penaltyReasons[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '카테고리: ${reason.category}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('설명: ${reason.description}'),
                      Text(
                        '시작: ${reason.startDate.toLocal().toString().split(' ')[0]} ${reason.startDate.toLocal().hour}:${reason.startDate.toLocal().minute}',
                      ),
                      Text(
                        '종료: ${reason.endDate.toLocal().toString().split(' ')[0]} ${reason.endDate.toLocal().hour}:${reason.endDate.toLocal().minute}',
                      ),
                      Text('패널티 ID: ${reason.penaltyId}'),
                    ],
                  ),
                ),
                if (reason.imageUrl != null)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      File(reason.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
