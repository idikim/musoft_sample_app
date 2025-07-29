import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/daily_schedule.dart';
import 'package:madezone_study_student_app/provider/daily_schedule_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScheduleDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const AddScheduleDialog({super.key, required this.selectedDate});

  @override
  ConsumerState<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends ConsumerState<AddScheduleDialog> {
  ScheduleCategory? _selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    _startTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      6,
      0,
    );
    _endTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      7,
      0,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      backgroundColor: Colors.grey.shade100,
      title: const Text(
        '스케줄 추가',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('카테고리:'),
              Row(
                children: [
                  ChoiceChip(
                    selectedColor: Colors.black12,
                    selectedShadowColor: Colors.black12,
                    backgroundColor: Colors.white,
                    label: const Text('공부기록'),
                    selected: _selectedCategory == ScheduleCategory.study,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory =
                            selected ? ScheduleCategory.study : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selectedColor: Colors.black12,
                    selectedShadowColor: Colors.black12,
                    backgroundColor: Colors.white,
                    label: const Text('벌점기록'),
                    selected: _selectedCategory == ScheduleCategory.penalty,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory =
                            selected ? ScheduleCategory.penalty : null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              _buildTimePicker('시작 시간', _startTime, (newTime) {
                setState(() {
                  _startTime = newTime;
                });
              }),
              const SizedBox(height: 16),
              _buildTimePicker('끝 시간', _endTime, (newTime) {
                setState(() {
                  _endTime = newTime;
                });
              }),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            _addSchedule();
          },
          child: const Text('추가'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    String label,
    DateTime currentTime,
    ValueChanged<DateTime> onDateTimeChanged, {
    DateTime? minTimeLimit,
  }) {
    final selectedDate = widget.selectedDate;
    DateTime effectiveMinimumDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      6,
      0,
    );
    final maximumDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
    );

    if (minTimeLimit != null && minTimeLimit.isAfter(effectiveMinimumDate)) {
      effectiveMinimumDate = minTimeLimit;
    }

    DateTime initialPickerTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      6,
      0,
    );
    if (initialPickerTime.isBefore(effectiveMinimumDate)) {
      initialPickerTime = effectiveMinimumDate;
    }
    if (initialPickerTime.isAfter(maximumDate)) {
      initialPickerTime = maximumDate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              minimumDate: effectiveMinimumDate,
              maximumDate: maximumDate,
              backgroundColor: Colors.white,
              mode: CupertinoDatePickerMode.time,
              initialDateTime: initialPickerTime,
              onDateTimeChanged: onDateTimeChanged,
              use24hFormat: true,
            ),
          ),
        ),
      ],
    );
  }

  void _addSchedule() async {
    if (_selectedCategory == null) {
      _showToast('카테고리를 선택해주세요.');
      await Future.delayed(const Duration(milliseconds: 2000));
      return;
    }
    if (_titleController.text.isEmpty) {
      _showToast('제목을 입력해주세요.');
      await Future.delayed(const Duration(milliseconds: 2000));
      return;
    }
    if (_startTime.isAfter(_endTime)) {
      _showToast('시작 시간은 끝 시간보다 빠를 수 없습니다.');
      await Future.delayed(const Duration(milliseconds: 2000));
      return;
    }

    final newSchedule = DailySchedule(
      date: widget.selectedDate,
      startHour: _startTime.hour,
      startMinute: _startTime.minute,
      endHour: _endTime.hour,
      endMinute: _endTime.minute,
      title: _titleController.text,
      details:
          _contentController.text.isNotEmpty ? [_contentController.text] : null,
      color:
          _selectedCategory == ScheduleCategory.study
              ? Colors.green.shade100
              : Colors.red.shade100,
      category: _selectedCategory!,
    );

    ref.read(allDailySchedulesProvider.notifier).addSchedule(newSchedule);
    Navigator.of(context).pop();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
