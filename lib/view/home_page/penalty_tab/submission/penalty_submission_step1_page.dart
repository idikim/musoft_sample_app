import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty_category.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';

class PenaltySubmissionStep1Page extends ConsumerWidget {
  final Penalty? penalty;
  const PenaltySubmissionStep1Page({super.key, this.penalty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReasonSelection(penalty: penalty),
        _DateSelection(penalty: penalty),
        const _TimeSelection(),
        _ReasonInput(),
      ],
    );
  }
}

class _ReasonSelection extends ConsumerStatefulWidget {
  final Penalty? penalty;
  const _ReasonSelection({this.penalty});

  @override
  ConsumerState<_ReasonSelection> createState() => _ReasonSelectionState();
}

class _ReasonSelectionState extends ConsumerState<_ReasonSelection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.penalty != null) {
        ref.read(selectedReasonProvider.notifier).state =
            widget.penalty!.category as PenaltyCategory?;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedReason = ref.watch(selectedReasonProvider);
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사유 선택',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: 4,
          children: [
            _ReasonChip(
              text: '결석',
              isSelected: selectedReason == PenaltyCategory.absence,
              onTap: () {
                ref.read(selectedReasonProvider.notifier).state =
                    PenaltyCategory.absence;
                ref.read(isAbsenceSelectedProvider.notifier).state = true;
              },
            ),
            _ReasonChip(
              text: '지각',
              isSelected: selectedReason == PenaltyCategory.tardy,
              onTap: () {
                ref.read(selectedReasonProvider.notifier).state =
                    PenaltyCategory.tardy;
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '외출',
              isSelected: selectedReason == PenaltyCategory.outing,
              onTap: () {
                ref.read(selectedReasonProvider.notifier).state =
                    PenaltyCategory.outing;
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '조퇴',
              isSelected: selectedReason == PenaltyCategory.earlyLeave,
              onTap: () {
                ref.read(selectedReasonProvider.notifier).state =
                    PenaltyCategory.earlyLeave;
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '학습태도',
              isSelected: selectedReason == PenaltyCategory.learningAttitude,
              onTap: () {
                ref.read(selectedReasonProvider.notifier).state =
                    PenaltyCategory.learningAttitude;
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ReasonChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ReasonChip({required this.text, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DateSelection extends ConsumerStatefulWidget {
  final Penalty? penalty;
  const _DateSelection({this.penalty});

  @override
  ConsumerState<_DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends ConsumerState<_DateSelection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedDateProvider.notifier).state =
          widget.penalty?.createdAt ?? DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('날짜', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showCupertinoDialog<DateTime>(
              context: context,
              builder: (BuildContext context) {
                DateTime tempPickedDate = selectedDate;
                return CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoAlertDialog(
                    content: SizedBox(
                      height: 200,
                      child: Localizations.override(
                        context: context,
                        locale: const Locale('ko', 'KR'),
                        child: CupertinoDatePicker(
                          initialDateTime: selectedDate,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            tempPickedDate = newDate;
                          },
                        ),
                      ),
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('선택'),
                        onPressed: () {
                          Navigator.of(context).pop(tempPickedDate);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
            if (picked != null && picked != selectedDate) {
              ref.read(selectedDateProvider.notifier).state = picked;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${DateFormat('EEEE', 'ko_KR').format(selectedDate)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeSelection extends ConsumerStatefulWidget {
  const _TimeSelection();

  @override
  ConsumerState<_TimeSelection> createState() => _TimeSelectionState();
}

class _TimeSelectionState extends ConsumerState<_TimeSelection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final now = DateTime.now();
      ref.read(selectedStartTimeProvider.notifier).state = DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
      );
      ref.read(selectedEndTimeProvider.notifier).state = DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
      );
    });
  }

  String _getDurationText(DateTime startTime, DateTime endTime) {
    final Duration duration = endTime.difference(startTime);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '$hours시간 $minutes분';
  }

  @override
  Widget build(BuildContext context) {
    final isAbsenceSelected = ref.watch(isAbsenceSelectedProvider);
    final selectedStartTime = ref.watch(selectedStartTimeProvider);
    final selectedEndTime = ref.watch(selectedEndTimeProvider);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          spacing: 8,
          children: [
            GestureDetector(
              onTap:
                  isAbsenceSelected
                      ? null
                      : () async {
                        final DateTime? picked =
                            await showCupertinoDialog<DateTime>(
                              context: context,
                              builder: (BuildContext context) {
                                DateTime tempPickedTime = selectedStartTime;
                                return CupertinoTheme(
                                  data: const CupertinoThemeData(
                                    brightness: Brightness.light,
                                  ),
                                  child: CupertinoAlertDialog(
                                    content: SizedBox(
                                      height: 200,
                                      child: CupertinoDatePicker(
                                        initialDateTime: selectedStartTime,
                                        mode: CupertinoDatePickerMode.time,
                                        onDateTimeChanged: (DateTime newTime) {
                                          tempPickedTime = newTime;
                                        },
                                      ),
                                    ),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('선택'),
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(tempPickedTime);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                        if (picked != null && picked != selectedStartTime) {
                          ref.read(selectedStartTimeProvider.notifier).state =
                              picked;
                          if (selectedEndTime.isBefore(picked)) {
                            ref
                                .read(selectedEndTimeProvider.notifier)
                                .state = picked.add(const Duration(hours: 1));
                          }
                        }
                      },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isAbsenceSelected ? Colors.grey[300] : null,
                  border:
                      isAbsenceSelected
                          ? Border.all(color: Colors.grey[300]!)
                          : Border.all(),
                ),
                child: Text(
                  DateFormat('HH:mm').format(selectedStartTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: isAbsenceSelected ? Colors.black45 : Colors.black,
                  ),
                ),
              ),
            ),
            Text('-'),
            GestureDetector(
              onTap:
                  isAbsenceSelected
                      ? null
                      : () async {
                        final DateTime? picked =
                            await showCupertinoDialog<DateTime>(
                              context: context,
                              builder: (BuildContext context) {
                                DateTime tempPickedTime = selectedEndTime;
                                return CupertinoTheme(
                                  data: const CupertinoThemeData(
                                    brightness: Brightness.light,
                                  ),
                                  child: CupertinoAlertDialog(
                                    content: SizedBox(
                                      height: 200,
                                      child: CupertinoDatePicker(
                                        initialDateTime: selectedEndTime,
                                        mode: CupertinoDatePickerMode.time,
                                        onDateTimeChanged: (DateTime newTime) {
                                          tempPickedTime = newTime;
                                        },
                                      ),
                                    ),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('선택'),
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(tempPickedTime);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                        if (picked != null && picked != selectedEndTime) {
                          ref.read(selectedEndTimeProvider.notifier).state =
                              picked;
                          if (picked.isBefore(selectedStartTime)) {
                            ref.read(selectedStartTimeProvider.notifier).state =
                                picked.subtract(const Duration(hours: 1));
                          }
                        }
                      },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isAbsenceSelected ? Colors.grey[300] : null,
                  border:
                      isAbsenceSelected
                          ? Border.all(color: Colors.grey[300]!)
                          : Border.all(),
                ),
                child: Text(
                  DateFormat('HH:mm').format(selectedEndTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: isAbsenceSelected ? Colors.black45 : Colors.black,
                  ),
                ),
              ),
            ),
            Text(
              _getDurationText(selectedStartTime, selectedEndTime),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReasonInput extends ConsumerStatefulWidget {
  const _ReasonInput();

  @override
  ConsumerState<_ReasonInput> createState() => _ReasonInputState();
}

class _ReasonInputState extends ConsumerState<_ReasonInput> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    Future.microtask(() {
      ref.read(reasonInputProvider.notifier).state = _controller.text;
    });
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
      ref.read(reasonInputProvider.notifier).state = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              '벌점 사유',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('(100자 이하)', style: TextStyle(color: Colors.grey)),
          ],
        ),
        TextField(
          controller: _controller,
          maxLines: 5,
          maxLength: 100,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '사유를 자세하게 작성해주세요',
            counterText: '',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$_charCount/100',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
