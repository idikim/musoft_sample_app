import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';

class PenaltyDetailPage extends ConsumerWidget {
  final Penalty penalty;
  final VoidCallback onBack;

  const PenaltyDetailPage({
    super.key,
    required this.penalty,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penaltyReasonsAsyncValue = ref.watch(penaltyReasonsProvider);
    final isAbsenceSelected = ref.watch(isAbsenceSelectedProvider);
    final selectedStartTime = ref.watch(selectedStartTimeProvider);
    final selectedEndTime = ref.watch(selectedEndTimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사유 제출 내역 상세보기'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: penaltyReasonsAsyncValue.when(
        data: (penaltyReasons) {
          final PenaltyReason correspondingReason = penaltyReasons.firstWhere(
            (reason) => reason.penaltyId == penalty.id,
            orElse:
                () => PenaltyReason(
                  id: '',
                  category: penalty.category,
                  penaltyId: '',
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  userReason: '',
                ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(),
                              ),
                              child: Text(
                                penalty.category.displayName,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Text(
                              penalty.points == 0
                                  ? (penalty.category.displayName == '지각' ||
                                          penalty.category.displayName == '조퇴'
                                      ? '-5점'
                                      : '-10점')
                                  : '-${penalty.points}점',
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
                                        !penalty.isReasonSubmitted
                                            ? Border.fromBorderSide(
                                              BorderSide.none,
                                            )
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

                    penalty.description == ''
                        ? Container()
                        : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Text('사유: ${penalty.description}'),
                          ),
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Divider(color: Colors.grey[300], thickness: 8),
              ),
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
                        ).format(correspondingReason.startDate),
                      ),
                    ),
                    Text('시간'),
                    Row(
                      spacing: 12,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isAbsenceSelected ? Colors.grey[300] : null,
                            border:
                                isAbsenceSelected
                                    ? Border.all(color: Colors.grey[300]!)
                                    : Border.all(),
                          ),
                          child: Text(
                            DateFormat(
                              'HH:mm',
                            ).format(correspondingReason.startDate),
                            style: TextStyle(
                              color:
                                  isAbsenceSelected
                                      ? Colors.black45
                                      : Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isAbsenceSelected ? Colors.grey[300] : null,
                            border:
                                isAbsenceSelected
                                    ? Border.all(color: Colors.grey[300]!)
                                    : Border.all(),
                          ),
                          child: Text(
                            DateFormat(
                              'HH:mm',
                            ).format(correspondingReason.endDate),
                            style: TextStyle(
                              color:
                                  isAbsenceSelected
                                      ? Colors.black45
                                      : Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          _getDurationText(selectedStartTime, selectedEndTime),
                          style: TextStyle(
                            color:
                                isAbsenceSelected
                                    ? Colors.black45
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text('내가 제출한 사유'),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Text(correspondingReason.userReason),
                    ),

                    correspondingReason.imageUrls != null
                        ? Text('첨부파일')
                        : Container(),
                    Row(
                      spacing: 8,
                      children: [
                        if (correspondingReason.imageUrls != null)
                          ...correspondingReason.imageUrls!.map(
                            (imageUrl) => attachedImage(context, imageUrl),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget attachedImage(BuildContext context, String? imageUrl) {
    if (imageUrl == null) {
      return const SizedBox.shrink();
    }
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
                    Text(imageUrl.split('/').last),
                    SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Image.file(File(imageUrl), fit: BoxFit.contain),
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
        child: Image.file(File(imageUrl), fit: BoxFit.cover),
      ),
    );
  }

  String _getDurationText(DateTime startTime, DateTime endTime) {
    final Duration duration = endTime.difference(startTime);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '$hours시간 $minutes분';
  }
}
