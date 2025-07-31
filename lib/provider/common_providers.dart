import 'package:flutter_riverpod/flutter_riverpod.dart';

final penaltyViewModeProvider = StateProvider<bool>((ref) => true);
final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final isDatePickerOpenProvider = StateProvider<bool>((ref) => false);

/// 마이스케줄 날짜선택 프로바이더
final selectedDayProvider = StateProvider<int?>((ref) => DateTime.now().day);

/// 선택된 시작 시간
final selectedStartTimeProvider = StateProvider<DateTime>(
  (ref) => _getDefaultTime(),
);

/// 선택된 종료 시간
final selectedEndTimeProvider = StateProvider<DateTime>(
  (ref) => _getDefaultTime(),
);

/// 기본 시간 반환 헬퍼 함수
DateTime _getDefaultTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 0, 0);
}
