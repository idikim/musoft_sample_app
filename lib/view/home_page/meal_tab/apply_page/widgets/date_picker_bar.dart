import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DatePickerBar extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final int daysToShow;

  const DatePickerBar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.daysToShow = 30,
  });

  @override
  State<DatePickerBar> createState() => _DatePickerBarState();
}

class _DatePickerBarState extends State<DatePickerBar> {
  late DateTime selectedDate;
  late List<DateTime> dateList;
  final ScrollController _scrollController = ScrollController();
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    dateList = List.generate(
      widget.daysToShow,
      (i) => DateTime.now().add(Duration(days: i)),
    );
    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {
        _localeInitialized = true;
      });
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeInitialized) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        height: 80,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: dateList.length,
          itemBuilder: (context, index) {
            final date = dateList[index];
            final isSelected = _isSameDay(date, selectedDate);
            final weekday = date.weekday;
            final isWeekend =
                weekday == DateTime.saturday || weekday == DateTime.sunday;
            final textColor = isWeekend ? Colors.red : Colors.black;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
                widget.onDateSelected(date);
              },
              child: Container(
                width: 56,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12 : 4,
                  right: index == 29 ? 12 : 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.black
                          : Colors.black.withOpacity(0.025),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E('ko_KR').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : textColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${date.month}/',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : textColor,
                          ),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
