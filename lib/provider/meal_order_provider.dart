import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/meal_order.dart';
import '../repository/meal_order_repository.dart';

final mealOrderProvider = FutureProvider<List<MealOrder>>((ref) async {
  return await MealOrderRepository.loadOrders();
});

final mealOrderAddProvider = Provider((ref) => MealOrderAddNotifier(ref));

class MealOrderAddNotifier {
  final Ref ref;
  MealOrderAddNotifier(this.ref);

  Future<void> addOrder(MealOrder order) async {
    final orders = await MealOrderRepository.loadOrders();
    final updated = [...orders, order];
    await MealOrderRepository.saveOrders(updated);
    ref.invalidate(mealOrderProvider);
  }
}
