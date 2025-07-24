import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        const _ReasonInput(),
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
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    if (widget.penalty != null) {
      _selectedReason = widget.penalty!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              isSelected: _selectedReason == '결석',
              onTap: () {
                setState(() => _selectedReason = '결석');
                ref.read(isAbsenceSelectedProvider.notifier).state = true;
              },
            ),
            _ReasonChip(
              text: '지각',
              isSelected: _selectedReason == '지각',
              onTap: () {
                setState(() => _selectedReason = '지각');
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '외출',
              isSelected: _selectedReason == '외출',
              onTap: () {
                setState(() => _selectedReason = '외출');
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '조퇴',
              isSelected: _selectedReason == '조퇴',
              onTap: () {
                setState(() => _selectedReason = '조퇴');
                ref.read(isAbsenceSelectedProvider.notifier).state = false;
              },
            ),
            _ReasonChip(
              text: '학습태도',
              isSelected: _selectedReason == '학습태도',
              onTap: () {
                setState(() => _selectedReason = '학습태도');
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

class _DateSelection extends StatefulWidget {
  final Penalty? penalty;
  const _DateSelection({this.penalty});

  @override
  State<_DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<_DateSelection> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.penalty?.createdAt ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
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
                DateTime tempPickedDate = _selectedDate;
                return CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.light),
                  child: CupertinoAlertDialog(
                    content: SizedBox(
                      height: 200,
                      child: Localizations.override(
                        context: context,
                        locale: const Locale('ko', 'KR'),
                        child: CupertinoDatePicker(
                          initialDateTime: _selectedDate,
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
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')} ${DateFormat('EEEE', 'ko_KR').format(_selectedDate)}',
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
  late DateTime _selectedStartTime;
  late DateTime _selectedEndTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedStartTime = DateTime(now.year, now.month, now.day, 0, 0);
    _selectedEndTime = DateTime(now.year, now.month, now.day, 0, 0);
  }

  String _getDurationText() {
    final Duration duration = _selectedEndTime.difference(_selectedStartTime);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '$hours시간 $minutes분';
  }

  @override
  Widget build(BuildContext context) {
    final isAbsenceSelected = ref.watch(isAbsenceSelectedProvider);

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
                                DateTime tempPickedTime = _selectedStartTime;
                                return CupertinoTheme(
                                  data: const CupertinoThemeData(
                                    brightness: Brightness.light,
                                  ),
                                  child: CupertinoAlertDialog(
                                    content: SizedBox(
                                      height: 200,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _selectedStartTime,
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
                        if (picked != null && picked != _selectedStartTime) {
                          setState(() {
                            _selectedStartTime = picked;
                            if (_selectedEndTime.isBefore(_selectedStartTime)) {
                              _selectedEndTime = _selectedStartTime.add(
                                const Duration(hours: 1),
                              );
                            }
                          });
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
                  DateFormat('HH:mm').format(_selectedStartTime),
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
                                DateTime tempPickedTime = _selectedEndTime;
                                return CupertinoTheme(
                                  data: const CupertinoThemeData(
                                    brightness: Brightness.light,
                                  ),
                                  child: CupertinoAlertDialog(
                                    content: SizedBox(
                                      height: 200,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _selectedEndTime,
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
                        if (picked != null && picked != _selectedEndTime) {
                          setState(() {
                            _selectedEndTime = picked;
                            if (_selectedEndTime.isBefore(_selectedStartTime)) {
                              _selectedStartTime = _selectedEndTime.subtract(
                                const Duration(hours: 1),
                              );
                            }
                          });
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
                  DateFormat('HH:mm').format(_selectedEndTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: isAbsenceSelected ? Colors.black45 : Colors.black,
                  ),
                ),
              ),
            ),
            Text(
              _getDurationText(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReasonInput extends StatefulWidget {
  const _ReasonInput();

  @override
  State<_ReasonInput> createState() => _ReasonInputState();
}

class _ReasonInputState extends State<_ReasonInput> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
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
