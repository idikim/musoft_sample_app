import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/meal_order.dart';
import 'package:madezone_study_student_app/provider/meal_order_provider.dart';

class ItemMealStatus extends ConsumerWidget {
  final MealOrder order;
  const ItemMealStatus({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  order.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.fastfood, size: 48),
                ),
              ),
            ),
            title: Text(
              order.menuName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('가격 : ${order.price}원'),
                Text(
                  '신청일자 : ${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString()} (${order.mealType})',
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.pinkAccent[100]),
              iconSize: 20,
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => CupertinoAlertDialog(
                        title: Text('도시락 주문 취소'),
                        content: Text('도시락 주문을 취소하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                );
                if (result == true) {
                  await ref.read(mealOrderAddProvider).deleteOrder(order);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('주문이 취소되었습니다.')));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
