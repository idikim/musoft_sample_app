import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/meal.dart';
import 'package:madezone_study_student_app/repository/meal_order_repository.dart';

final mealOrderProvider = FutureProvider<List<MealOrder>>((ref) async {
  return await MealOrderRepository.loadOrders();
});

final mealOrderAddProvider = Provider((ref) => MealOrderAddNotifier(ref));
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedMealTypeProvider = StateProvider<String>((ref) => '점심');
final selectedMealIndexProvider = StateProvider<int?>((ref) => null);
final isOrderingProvider = StateProvider<bool>((ref) => false);

class MealOrderAddNotifier {
  final Ref ref;
  MealOrderAddNotifier(this.ref);

  Future<void> addOrder(MealOrder order) async {
    final orders = await MealOrderRepository.loadOrders();
    try {
      final existingOrder = orders.firstWhere(
        (o) =>
            o.date.year == order.date.year &&
            o.date.month == order.date.month &&
            o.date.day == order.date.day &&
            o.mealType == order.mealType &&
            o.menuName == order.menuName,
      );
      existingOrder.quantity += order.quantity;
    } catch (e) {
      orders.add(order);
    }
    await MealOrderRepository.saveOrders(orders);
    ref.invalidate(mealOrderProvider);
  }

  Future<void> deleteOrder(MealOrder order) async {
    await MealOrderRepository.deleteOrder(order);
    ref.invalidate(mealOrderProvider);
  }
}
