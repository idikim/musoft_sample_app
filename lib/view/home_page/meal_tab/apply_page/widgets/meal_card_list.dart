import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/meal.dart';
import 'package:madezone_study_student_app/view/home_page/meal_tab/apply_page/widgets/item_meal_card.dart';
import 'package:madezone_study_student_app/view/widgets/animated_tap_scale.dart';

class MealCardList extends StatefulWidget {
  final int? selectedIndex;
  final ValueChanged<int> onMealSelected;
  final List<Meal> meals;
  const MealCardList({
    super.key,
    this.selectedIndex,
    required this.onMealSelected,
    required this.meals,
  });

  @override
  State<MealCardList> createState() => _MealCardListState();
}

class _MealCardListState extends State<MealCardList> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 20 * 2;
    final double spacing = 16;
    final int crossAxisCount = 2;
    final double itemWidth =
        (screenWidth - horizontalPadding - spacing) / crossAxisCount;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: 4,
              children: List.generate(widget.meals.length, (index) {
                final meal = widget.meals[index];
                return SizedBox(
                  width: itemWidth,
                  child: AnimatedTapScale(
                    onTap: () => widget.onMealSelected(index),
                    scaleFactor: 1.05,
                    child: ItemMealCard(
                      imageUrl: meal.imageUrl,
                      menu: meal.menu,
                      description: meal.description,
                      price: meal.price,
                      selected: widget.selectedIndex == index,
                      onTap: null,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
