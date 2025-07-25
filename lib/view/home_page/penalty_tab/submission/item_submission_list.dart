import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';

class ItemSubmissionList extends StatelessWidget {
  final List<PenaltyReason> penaltyReasons;

  const ItemSubmissionList({super.key, required this.penaltyReasons});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: penaltyReasons.length,
      itemBuilder: (context, index) {
        final reason = penaltyReasons[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Text(
                            DateFormat(
                              'M월 d일 (E)',
                              'ko_KR',
                            ).format(reason.startDate),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Text(
                              reason.category.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${DateFormat('HH:mm').format(reason.startDate.toLocal())} - ${DateFormat('HH:mm').format(reason.endDate.toLocal())}',
                      ),
                      Text(
                        '벌점 사유 : ${reason.description}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '제출 내용 : ${reason.userReason}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (reason.imageUrl != null)
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.file(
                        File(reason.imageUrl!),
                        fit: BoxFit.cover,
                      ),
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
