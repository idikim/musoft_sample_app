import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/model/meal.dart';
import 'package:madezone_study_student_app/provider/meal_order_provider.dart';
import 'package:madezone_study_student_app/view/widgets/animated_tap_scale.dart';
import 'widgets/date_picker_bar.dart';
import 'widgets/meal_card_list.dart';
import 'meal_sample_data.dart';

class MealApplyPage extends ConsumerStatefulWidget {
  const MealApplyPage({super.key});

  @override
  ConsumerState<MealApplyPage> createState() => _MealApplyPageState();
}

class _MealApplyPageState extends ConsumerState<MealApplyPage> {
  static const double _buttonHeight = 80.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _iconSize = 20.0;
  static const double _loadingIndicatorSize = 18.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedMeal = ref.watch(selectedMealTypeProvider);
    final selectedMealIndex = ref.watch(selectedMealIndexProvider);
    final isOrdering = ref.watch(isOrderingProvider);
    final meals = getMealsFor(selectedDate, selectedMeal);

    return Column(
      children: [
        _buildDatePicker(selectedDate),
        _buildMealTypeSelector(selectedMeal),
        _buildDivider(),
        _buildMealList(meals, selectedMealIndex),
        _buildOrderButton(selectedMealIndex, isOrdering),
      ],
    );
  }

  Widget _buildDatePicker(DateTime selectedDate) {
    return DatePickerBar(
      initialDate: selectedDate,
      onDateSelected: (date) {
        ref.read(selectedDateProvider.notifier).state = date;
        ref.read(selectedMealIndexProvider.notifier).state = null;
      },
    );
  }

  Widget _buildMealTypeSelector(String selectedMeal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SelectButton(
            text: '점심',
            selected: selectedMeal == '점심',
            onTap: () => _onMealTypeChanged('점심'),
          ),
          _SelectButton(
            text: '저녁',
            selected: selectedMeal == '저녁',
            onTap: () => _onMealTypeChanged('저녁'),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: const BoxDecoration(color: Colors.black12),
    );
  }

  Widget _buildMealList(List<Meal> meals, int? selectedMealIndex) {
    return Expanded(
      child: Container(
        color: Colors.grey[100],
        child: MealCardList(
          selectedIndex: selectedMealIndex,
          onMealSelected: (index) {
            ref.read(selectedMealIndexProvider.notifier).state = index;
          },
          meals: meals,
        ),
      ),
    );
  }

  Widget _buildOrderButton(int? selectedMealIndex, bool isOrdering) {
    final isEnabled = selectedMealIndex != null && !isOrdering;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      width: double.infinity,
      height: _buttonHeight,
      child: AnimatedTapScale(
        onTap: isEnabled ? _orderMeal : null,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_buttonBorderRadius),
                ),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              isEnabled ? Colors.blueAccent : Colors.black26,
            ),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            elevation: WidgetStatePropertyAll(isEnabled ? 8 : 0),
            shadowColor: WidgetStatePropertyAll(
              isEnabled ? Colors.black.withOpacity(0.3) : Colors.transparent,
            ),
          ),
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOrdering) ...[
                SizedBox(
                  width: _loadingIndicatorSize,
                  height: _loadingIndicatorSize,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: _spacing),
              ],
              const Icon(Icons.shopping_cart_outlined, size: _iconSize),
              const SizedBox(width: _spacing),
              const Text(
                '도시락 주문하기',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMealTypeChanged(String mealType) {
    ref.read(selectedMealTypeProvider.notifier).state = mealType;
    ref.read(selectedMealIndexProvider.notifier).state = null;
  }

  Future<void> _orderMeal() async {
    final selectedMealIndex = ref.read(selectedMealIndexProvider);
    if (selectedMealIndex == null) return;

    ref.read(isOrderingProvider.notifier).state = true;

    try {
      await _createAndAddOrder(selectedMealIndex);
      _showOrderDialog();
    } finally {
      ref.read(isOrderingProvider.notifier).state = false;
    }
  }

  Future<void> _createAndAddOrder(int selectedMealIndex) async {
    final selectedDate = ref.read(selectedDateProvider);
    final selectedMeal = ref.read(selectedMealTypeProvider);
    final meals = getMealsFor(selectedDate, selectedMeal);
    final meal = meals[selectedMealIndex];

    final order = MealOrder(
      thumbnailUrl: meal.imageUrl,
      menuName: meal.menu,
      price: int.tryParse(meal.price.replaceAll(',', '')) ?? 0,
      date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      mealType: selectedMeal,
      quantity: 1,
      status: '주문확인중',
    );

    await ref.read(mealOrderAddProvider).addOrder(order);
    ref.read(selectedMealIndexProvider.notifier).state = null;
  }

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('주문이 완료되었습니다!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
