import 'package:flutter/material.dart';

class Meal {
  final String imageUrl;
  final String vendor;
  final String menu;
  final String price;

  const Meal({
    required this.imageUrl,
    required this.vendor,
    required this.menu,
    required this.price,
  });
}

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
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.meals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final meal = widget.meals[index];
          return MealCard(
            imageUrl: meal.imageUrl,
            vendor: meal.vendor,
            menu: meal.menu,
            price: meal.price,
            selected: widget.selectedIndex == index,
            onTap: () => widget.onMealSelected(index),
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String imageUrl;
  final String vendor;
  final String menu;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.imageUrl,
    required this.vendor,
    required this.menu,
    required this.price,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vendor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            Text(
              menu,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
