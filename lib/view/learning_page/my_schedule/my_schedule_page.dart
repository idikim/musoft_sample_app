import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';
import 'package:madezone_study_student_app/provider/daily_schedule_provider.dart';
import 'package:madezone_study_student_app/view/learning_page/my_schedule/widgets/add_schedule_dialog.dart';
import 'widgets/date_picker_bottom_sheet.dart';
import 'widgets/schedule_table.dart';
import 'package:intl/intl.dart';
import '../../home_page/penalty_tab/my_penalty/calendar/my_penalty_calendar_page.dart';

class MySchedulePage extends ConsumerWidget {
  const MySchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final isScheduleChecked = ref.watch(_scheduleCheckProvider);
    final selectedViewType = ref.watch(_selectedViewTypeProvider);
    final selectedYear = ref.watch(selectedYearProvider);
    final allSchedules = ref.watch(allDailySchedulesProvider);

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (allSchedules.isEmpty)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -36,
                  left: -24,
                  right: -24,
                  child: ClipPath(
                    clipper: BubbleClipper(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 4, 12, 12),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '샘플데이터 추가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: CircleBorder(),
                  onPressed: () {
                    ref
                        .read(allDailySchedulesProvider.notifier)
                        .addSampleSchedules();
                  },
                  child: const Icon(Icons.add_chart, size: 24),
                ),
              ],
            ),
          SizedBox(width: 16),
          FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            onPressed: () {
              _showAddScheduleDialog(
                context,
                ref.read(selectedYearProvider),
                ref.read(selectedMonthProvider),
                ref.read(selectedDayProvider)!,
              );
            },
            child: const Icon(Icons.add, size: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),

            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(isDatePickerOpenProvider.notifier).state = true;
                    _showDatePickerBottomSheet(context, ref);
                  },
                  child: Row(
                    children: [
                      Text(
                        '$selectedMonth월',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 28),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildViewTypeButton(
                          ref,
                          'assets/images/svg/Group 256.svg',
                          '일',
                          ViewType.daily,
                          selectedViewType,
                        ),
                        _buildViewTypeButton(
                          ref,
                          'assets/images/svg/Group 255.svg',
                          '주',
                          ViewType.weekly,
                          selectedViewType,
                        ),
                        _buildViewTypeButton(
                          ref,
                          'assets/images/svg/Group 257.svg',
                          '월',
                          ViewType.monthly,
                          selectedViewType,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    CheckboxMenuButton(
                      style: ButtonStyle(visualDensity: VisualDensity.compact),
                      value: isScheduleChecked,
                      onChanged: (val) {
                        ref.read(_scheduleCheckProvider.notifier).state =
                            val ?? false;
                      },
                      child: Text(
                        '학사일정',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (selectedViewType == ViewType.weekly)
            (selectedDay != null)
                ? _buildWeeklyCalendar(
                  ref,
                  selectedYear,
                  selectedMonth,
                  selectedDay,
                  isScheduleChecked,
                )
                : SizedBox.shrink()
          else if (selectedViewType == ViewType.monthly)
            Expanded(
              child: MyPenaltyCalendarPage(
                initialMonth: DateTime(selectedYear, selectedMonth),
                dayCellBuilder:
                    (date) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    date.month == selectedMonth
                                        ? Colors.black
                                        : Colors.black26,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildSummaryCardForDate(
                            ref,
                            date,
                            viewType: ViewType.monthly,
                          ),
                          Spacer(),
                          if (isScheduleChecked &&
                              date.weekday == DateTime.friday)
                            Container(
                              width: double.infinity,
                              color: Colors.black,
                              padding: const EdgeInsets.all(2),
                              child: const Text(
                                '모의고사',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.EEEE(
                          'ko_KR',
                        ).format(DateTime(2024, 7, 29 + (selectedDay! - 1))),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$selectedDay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ref.watch(
                            totalStudyMinutesForDateProvider(
                              DateTime(
                                selectedYear,
                                selectedMonth,
                                selectedDay,
                              ),
                            ),
                          ) >
                          0
                      ? Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: _buildSummaryCardForDate(
                            ref,
                            DateTime(selectedYear, selectedMonth, selectedDay),
                            viewType: selectedViewType,
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          if (selectedViewType != ViewType.monthly)
            Expanded(
              child: ScheduleTable(
                selectedDate: DateTime(
                  selectedYear,
                  selectedMonth,
                  selectedDay!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildViewTypeButton(
    WidgetRef ref,
    String svgPath,
    String label,
    ViewType viewType,
    ViewType selectedViewType,
  ) {
    final isSelected = selectedViewType == viewType;

    return GestureDetector(
      onTap: () {
        ref.read(_selectedViewTypeProvider.notifier).state = viewType;
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? Colors.grey.shade300 : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgPath),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DatePickerBottomSheet(),
    );
  }

  void _showAddScheduleDialog(
    BuildContext context,
    int year,
    int month,
    int day,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddScheduleDialog(selectedDate: DateTime(year, month, day));
      },
    );
  }
}

enum ViewType { daily, weekly, monthly }

final _scheduleCheckProvider = StateProvider<bool>((ref) => false);
final _selectedViewTypeProvider = StateProvider<ViewType>(
  (ref) => ViewType.daily,
);

bool isToday(DateTime d) {
  final now = DateTime.now();
  return d.year == now.year && d.month == now.month && d.day == now.day;
}

class DailyStudySummaryCard extends StatelessWidget {
  final String label;
  final String timeText;
  final double? iconSize;
  final double? textSize;

  const DailyStudySummaryCard({
    super.key,
    required this.label,
    required this.timeText,
    this.iconSize,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: Colors.green.shade100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.black54,
                size: iconSize ?? 12,
              ),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: textSize ?? 10),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Text(
            timeText,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: textSize ?? 10,
            ),
            overflow: TextOverflow.clip,
            softWrap: false,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

Widget _buildSummaryCardForDate(
  WidgetRef ref,
  DateTime date, {
  ViewType? viewType,
}) {
  final totalMinutes = ref.watch(totalStudyMinutesForDateProvider(date));

  if (totalMinutes <= 0) {
    return const SizedBox.shrink();
  }

  final timeText = _formatMinutes(totalMinutes);
  return DailyStudySummaryCard(
    label: '순공시간',
    timeText: timeText,
    iconSize: viewType == ViewType.daily ? 18 : null,
    textSize: viewType == ViewType.daily ? 14 : null,
  );
}

String _formatMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h > 0) {
    return '$h시간 $m분';
  } else {
    return '$m분';
  }
}

Widget _buildWeeklyCalendar(
  WidgetRef ref,
  int selectedYear,
  int selectedMonth,
  int selectedDay,
  bool isScheduleChecked,
) {
  final now = DateTime(selectedYear, selectedMonth, selectedDay);
  final weekStart = now.subtract(Duration(days: now.weekday % 7));
  final weekDates = List.generate(7, (i) => weekStart.add(Duration(days: i)));
  final weekDays = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];

  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < weekDays.length; i++)
              Expanded(
                child: Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  child: Text(
                    weekDays[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: i == 0 ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Container(
          color: Colors.grey.shade300,
          child: Row(
            children: [
              for (int i = 0; i < weekDates.length; i++)
                Expanded(
                  child: Container(
                    height: isScheduleChecked ? 85 : 65,
                    margin: EdgeInsets.only(right: i == 6 ? 0 : 1),
                    decoration: BoxDecoration(
                      border:
                          (weekDates[i].year == selectedYear &&
                                  weekDates[i].month == selectedMonth &&
                                  weekDates[i].day == selectedDay)
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                          child: Text(
                            '${weekDates[i].day}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  weekDates[i].month == selectedMonth
                                      ? null
                                      : Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildSummaryCardForDate(
                          ref,
                          weekDates[i],
                          viewType: ViewType.weekly,
                        ),
                        Spacer(),
                        if (isScheduleChecked &&
                            weekDates[i].weekday == DateTime.friday)
                          Container(
                            width: double.infinity,
                            color: Colors.black,
                            padding: const EdgeInsets.all(2),
                            child: const Text(
                              '모의고사',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - 8),
        Radius.circular(8),
      ),
    );

    path.moveTo(size.width / 2 - 6, size.height - 8);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 6, size.height - 8);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
