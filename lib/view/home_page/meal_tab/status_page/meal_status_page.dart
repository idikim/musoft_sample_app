import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musoft_sample_app/provider/meal_order_provider.dart';
import 'item_meal_status.dart';

class MealStatusPage extends ConsumerWidget {
  const MealStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(mealOrderProvider);
    return ordersAsync.when(
      data: (orders) {
        final reversedOrders = orders.reversed.toList();
        if (reversedOrders.isEmpty) {
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
                        for (int i = 0; i < reversedOrders.length; i++) ...[
                          ItemMealStatus(order: reversedOrders[i]),
                          if (i != reversedOrders.length - 1)
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
