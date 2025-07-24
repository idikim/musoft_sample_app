import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/meal_order_provider.dart';
import 'item_meal_status.dart';

class MealStatusPage extends ConsumerWidget {
  const MealStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(mealOrderProvider);
    return ordersAsync.when(
      data: (orders) {
        final indexedOrders = orders.asMap().entries.toList();
        indexedOrders.sort((a, b) {
          int cmp = a.value.date.compareTo(b.value.date);
          if (cmp != 0) return cmp;
          if (a.value.mealType != b.value.mealType) {
            if (a.value.mealType == '점심') return -1;
            if (b.value.mealType == '점심') return 1;
          }
          return b.key.compareTo(a.key);
        });
        final sortedOrders = indexedOrders.map((e) => e.value).toList();
        if (sortedOrders.isEmpty) {
          return const Center(
            child: Text('신청 내역이 없습니다.', style: TextStyle(fontSize: 20)),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < sortedOrders.length; i++) ...[
                          ItemMealStatus(order: sortedOrders[i]),
                          if (i != sortedOrders.length - 1)
                            SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('에러 발생: $e')),
    );
  }
}
