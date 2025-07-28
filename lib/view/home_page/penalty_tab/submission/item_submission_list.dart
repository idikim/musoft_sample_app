import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/penalty_provider.dart';

class ItemSubmissionList extends ConsumerWidget {
  final List<PenaltyReason> penaltyReasons;
  final Function(Penalty) onPenaltySelected;

  const ItemSubmissionList({
    super.key,
    required this.penaltyReasons,
    required this.onPenaltySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPenalties = ref.watch(penaltiesProvider);

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: penaltyReasons.length,
      itemBuilder: (context, index) {
        final reason = penaltyReasons[index];
        final correspondingPenalty = allPenalties.firstWhere(
          (penalty) => penalty.id == reason.penaltyId,
          orElse:
              () => Penalty(
                id: reason.penaltyId,
                points: 0,
                category: reason.category,
                createdAt: reason.startDate,
                description: '',
              ),
        );

        return GestureDetector(
          onTap: () {
            onPenaltySelected(correspondingPenalty);
          },
          child: Container(
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
                            // Text(
                            //   '${reason.id} / ${reason.penaltyId}',
                            //   style: TextStyle(fontSize: 10),
                            // ),
                          ],
                        ),
                        reason.category.displayName == '결석'
                            ? Container()
                            : Text(
                              '${DateFormat('HH:mm').format(reason.startDate.toLocal())} - ${DateFormat('HH:mm').format(reason.endDate.toLocal())}',
                            ),
                        correspondingPenalty.description == '' ||
                                correspondingPenalty.description == null
                            ? Container()
                            : Text(
                              '벌점 사유 : ${correspondingPenalty.description}',
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
                  if (reason.imageUrls != null && reason.imageUrls!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Image.file(
                          File(reason.imageUrls![0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
