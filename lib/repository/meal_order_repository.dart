import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madezone_study_student_app/model/meal_order.dart';

class MealOrderRepository {
  static const _key = 'meal_orders';

  static Future<void> saveOrders(List<MealOrder> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<MealOrder>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => MealOrder.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> deleteOrder(MealOrder order) async {
    final orders = await loadOrders();
    orders.removeWhere(
      (e) =>
          e.thumbnailUrl == order.thumbnailUrl &&
          e.menuName == order.menuName &&
          e.price == order.price &&
          e.date == order.date &&
          e.mealType == order.mealType,
    );
    await saveOrders(orders);
  }
}
