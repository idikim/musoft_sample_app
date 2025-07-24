import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/meal_order_provider.dart';
import 'package:madezone_study_student_app/provider/common_providers.dart'; // Add this line
import 'item_meal_status.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/meal_order.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class MealStatusPage extends ConsumerWidget {
  const MealStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(mealOrderProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return ordersAsync.when(
      data: (orders) {
        final filteredOrders =
            orders.where((order) {
              final matchesMonth =
                  selectedMonth == 0 || order.date.month == selectedMonth;
              final matchesSearch =
                  searchQuery.isEmpty ||
                  order.menuName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
              return matchesMonth && matchesSearch;
            }).toList();

        filteredOrders.sort((a, b) {
          int cmp = a.date.compareTo(b.date);
          if (cmp != 0) return cmp;
          if (a.mealType != b.mealType) {
            if (a.mealType == '점심') return -1;
            if (b.mealType == '점심') return 1;
          }
          return 0;
        });

        final groupedOrders = _groupOrdersByDate(filteredOrders);

        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged:
                              (query) =>
                                  ref.read(searchQueryProvider.notifier).state =
                                      query,
                          decoration: InputDecoration(
                            labelText: '메뉴를 찾아보세요',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<int>(
                    underline: Container(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    value: selectedMonth,
                    items: [
                      const DropdownMenuItem(value: 0, child: Text('전체')),
                      for (int i = 1; i <= 12; i++)
                        DropdownMenuItem(value: i, child: Text('$i월')),
                    ],
                    onChanged:
                        (month) =>
                            ref.read(selectedMonthProvider.notifier).state =
                                month!,
                  ),
                ),
                Expanded(
                  child:
                      filteredOrders.isEmpty
                          ? Center(
                            child: Text(
                              '신청 내역이 없습니다.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 100,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children:
                                      groupedOrders.entries.map((entry) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Text(
                                                DateFormat(
                                                  'M월 d일',
                                                ).format(entry.key),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children:
                                                  entry.value
                                                      .map(
                                                        (order) => Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 12.0,
                                                              ),
                                                          child: ItemMealStatus(
                                                            order: order,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('에러 발생: $e')),
    );
  }

  Map<DateTime, List<MealOrder>> _groupOrdersByDate(List<MealOrder> orders) {
    final Map<DateTime, List<MealOrder>> groupedOrders = {};
    for (var order in orders) {
      final date = DateTime(order.date.year, order.date.month, order.date.day);
      if (!groupedOrders.containsKey(date)) {
        groupedOrders[date] = [];
      }
      groupedOrders[date]!.add(order);
    }
    return groupedOrders;
  }
}
