import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// 공통 섹션 헤더 위젯
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 8),
              Text(subtitle!, style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ],
    );
  }
}

/// 공통 선택 가능한 컨테이너 위젯
class SelectableContainer extends StatelessWidget {
  final Widget child;
  final bool isDisabled;
  final VoidCallback? onTap;

  const SelectableContainer({
    super.key,
    required this.child,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDisabled ? Colors.grey[300]! : Colors.black,
          ),
          color: isDisabled ? Colors.grey[300] : null,
        ),
        child: child,
      ),
    );
  }
}

/// 공통 날짜 선택 다이얼로그
class CustomDatePickerDialog extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(fontSize: 18),
        ),
      ),
      child: CupertinoAlertDialog(
        content: SizedBox(
          height: 200,
          child: Localizations.override(
            context: context,
            locale: const Locale('ko', 'KR'),
            child: CupertinoDatePicker(
              initialDateTime: initialDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: onDateSelected,
            ),
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('선택'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// 공통 시간 선택 다이얼로그
class CustomTimePickerDialog extends StatelessWidget {
  final DateTime initialTime;
  final Function(DateTime) onTimeSelected;

  const CustomTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.light),
      child: CupertinoAlertDialog(
        content: SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            initialDateTime: initialTime,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: onTimeSelected,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('선택'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// 시간 포맷팅 유틸리티
class TimeUtils {
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${DateFormat('EEEE', 'ko_KR').format(date)}';
  }

  static String getDurationText(DateTime startTime, DateTime endTime) {
    final Duration duration = endTime.difference(startTime);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '$hours시간 $minutes분';
  }
}
