import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/steps/widgets/common_widgets.dart';

class PenaltySubmissionStep1Page extends ConsumerWidget {
  final Penalty? penalty;
  const PenaltySubmissionStep1Page({super.key, this.penalty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(),
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
        ref
            .read(penaltySubmissionLogicProvider)
            .initializeWithPenalty(widget.penalty!);
      } else {
        ref.read(isAbsenceSelectedProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPenaltyProvided = widget.penalty != null;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '사유 선택'),
        Row(spacing: 4, children: _buildReasonChips(isPenaltyProvided)),
      ],
    );
  }

  List<Widget> _buildReasonChips(bool isPenaltyProvided) {
    final reasons = [
      {'text': '결석', 'category': PenaltyCategory.absence},
      {'text': '지각', 'category': PenaltyCategory.tardy},
      {'text': '외출', 'category': PenaltyCategory.outing},
      {'text': '조퇴', 'category': PenaltyCategory.earlyLeave},
      {'text': '학습태도', 'category': PenaltyCategory.learningAttitude},
    ];

    return reasons.map((reason) {
      final category = reason['category'] as PenaltyCategory;
      final isSelected = ref.watch(selectedReasonProvider) == category;

      return _ReasonChip(
        text: reason['text'] as String,
        isSelected: isSelected,
        onTap: isPenaltyProvided ? null : () => _onReasonSelected(category),
      );
    }).toList();
  }

  void _onReasonSelected(PenaltyCategory category) {
    ref.read(selectedReasonProvider.notifier).state = category;
    ref.read(isAbsenceSelectedProvider.notifier).state =
        category == PenaltyCategory.absence;

    if (category == PenaltyCategory.absence) {
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
    }
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
    final bool isPenaltyProvided = widget.penalty != null;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '날짜'),
        SelectableContainer(
          isDisabled: isPenaltyProvided,
          onTap:
              isPenaltyProvided
                  ? null
                  : () => _showDatePicker(context, selectedDate),
          child: Text(
            TimeUtils.formatDate(selectedDate),
            style: TextStyle(
              fontSize: 16,
              color: isPenaltyProvided ? Colors.black45 : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    final DateTime? picked = await showCupertinoDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          initialDate: selectedDate,
          onDateSelected: (DateTime newDate) {},
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
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

  @override
  Widget build(BuildContext context) {
    final isAbsenceSelected = ref.watch(isAbsenceSelectedProvider);
    final selectedStartTime = ref.watch(selectedStartTimeProvider);
    final selectedEndTime = ref.watch(selectedEndTimeProvider);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '시간'),
        Row(
          spacing: 8,
          children: [
            _buildTimeSelector(
              selectedStartTime,
              isAbsenceSelected,
              (picked) => _onStartTimeChanged(picked, selectedEndTime),
            ),
            const Text('-'),
            _buildTimeSelector(
              selectedEndTime,
              isAbsenceSelected,
              (picked) => _onEndTimeChanged(picked, selectedStartTime),
            ),
            Text(
              TimeUtils.getDurationText(selectedStartTime, selectedEndTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAbsenceSelected ? Colors.black45 : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
    DateTime time,
    bool isDisabled,
    Function(DateTime) onTimeChanged,
  ) {
    return SelectableContainer(
      isDisabled: isDisabled,
      onTap:
          isDisabled
              ? null
              : () => _showTimePicker(context, time, onTimeChanged),
      child: Text(
        TimeUtils.formatTime(time),
        style: TextStyle(
          fontSize: 16,
          color: isDisabled ? Colors.black45 : Colors.black,
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    DateTime time,
    Function(DateTime) onTimeChanged,
  ) async {
    final DateTime? picked = await showCupertinoDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePickerDialog(
          initialTime: time,
          onTimeSelected: (DateTime newTime) {},
        );
      },
    );

    if (picked != null && picked != time) {
      onTimeChanged(picked);
    }
  }

  void _onStartTimeChanged(DateTime newStartTime, DateTime currentEndTime) {
    ref.read(selectedStartTimeProvider.notifier).state = newStartTime;
    if (currentEndTime.isBefore(newStartTime)) {
      ref.read(selectedEndTimeProvider.notifier).state = newStartTime.add(
        const Duration(hours: 1),
      );
    }
  }

  void _onEndTimeChanged(DateTime newEndTime, DateTime currentStartTime) {
    ref.read(selectedEndTimeProvider.notifier).state = newEndTime;
    if (newEndTime.isBefore(currentStartTime)) {
      ref.read(selectedStartTimeProvider.notifier).state = newEndTime.subtract(
        const Duration(hours: 1),
      );
    }
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
        const SectionHeader(title: '벌점 사유', subtitle: '(100자 이하)'),
        TextField(
          controller: _controller,
          maxLines: 3,
          maxLength: 100,
          decoration: const InputDecoration(
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
