import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/meal_order.dart';

class MealOrderRepository {
  static const _key = 'meal_orders';

  static Future<void> saveOrders(List<MealOrder> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        orders
            .map(
              (e) => jsonEncode({
                'thumbnailUrl': e.thumbnailUrl,
                'menuName': e.menuName,
                'price': e.price,
                'date': e.date.toIso8601String(),
                'mealType': e.mealType,
              }),
            )
            .toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<MealOrder>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => MealOrder.fromJson(jsonDecode(e))).toList();
  }
}
