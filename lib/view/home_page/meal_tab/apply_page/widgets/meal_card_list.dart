import 'package:flutter/material.dart';
import 'package:musoft_sample_app/model/meal.dart';
import 'package:musoft_sample_app/view/home_page/meal_tab/apply_page/widgets/item_meal_card.dart';

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
                  child: _AnimatedTapScale(
                    onTap: () => widget.onMealSelected(index),
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

class _AnimatedTapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _AnimatedTapScale({required this.child, this.onTap});

  @override
  State<_AnimatedTapScale> createState() => _AnimatedTapScaleState();
}

class _AnimatedTapScaleState extends State<_AnimatedTapScale>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 1.05;
    });
  }

  void _onTapUp(TapUpDetails details) async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _scale = 1.0;
    });
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
