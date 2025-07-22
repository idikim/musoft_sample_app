import 'package:flutter/material.dart';
import 'package:musoft_sample_app/model/meal_order.dart';

class ItemMealStatus extends StatelessWidget {
  final MealOrder order;
  const ItemMealStatus({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
      child: ListTile(
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
            Text('가격:  ${order.price}원'),
            Text(
              '신청일자:  ${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString()} (${order.mealType})',
            ),
          ],
        ),
      ),
    );
  }
}
