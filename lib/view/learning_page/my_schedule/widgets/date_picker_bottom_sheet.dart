import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart';

class DatePickerBottomSheet extends ConsumerStatefulWidget {
  const DatePickerBottomSheet({super.key});

  @override
  ConsumerState<DatePickerBottomSheet> createState() =>
      _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends ConsumerState<DatePickerBottomSheet> {
  late int selectedYear;
  late int selectedMonth;
  int? selectedDay;

  @override
  void initState() {
    super.initState();
    selectedYear = ref.read(selectedYearProvider);
    selectedMonth = ref.read(selectedMonthProvider);
    selectedDay = ref.read(selectedDayProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [Expanded(child: _buildYearMonthSelector())]),
            const SizedBox(height: 20),
            SizedBox(height: 300, child: _buildCalendar()),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    selectedDay != null
                        ? () {
                          ref.read(selectedYearProvider.notifier).state =
                              selectedYear;
                          ref.read(selectedMonthProvider.notifier).state =
                              selectedMonth;
                          ref.read(selectedDayProvider.notifier).state =
                              selectedDay;
                          ref.read(isDatePickerOpenProvider.notifier).state =
                              false;
                          Navigator.pop(context);
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '선택하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildYearMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Center(
            child: DropdownButtonFormField<int>(
              value: selectedYear,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              items: List.generate(10, (index) {
                final year = DateTime.now().year - 5 + index;
                return DropdownMenuItem(value: year, child: Text('$year년'));
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedYear = value;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 60,
          child: Center(
            child: DropdownButtonFormField<int>(
              value: selectedMonth,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              items: List.generate(12, (index) {
                final month = index + 1;
                return DropdownMenuItem(value: month, child: Text('$month월'));
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMonth = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        Row(
          children:
              ['일', '월', '화', '수', '목', '금', '토']
                  .map(
                    (day) => Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisExtent: 40,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayIndex = index - firstWeekday + 1;

              if (dayIndex < 1 || dayIndex > daysInMonth) {
                return Container();
              }

              final isSelected = selectedDay == dayIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = dayIndex;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? Colors.grey.shade400 : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      '$dayIndex',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
