import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/date_picker_bar.dart';
import 'widgets/meal_card_list.dart';

class MealApplyPage extends StatefulWidget {
  const MealApplyPage({super.key});

  @override
  State<MealApplyPage> createState() => _MealApplyPageState();
}

class _MealApplyPageState extends State<MealApplyPage> {
  DateTime selectedDate = DateTime.now();
  String selectedMeal = '점심';
  int? selectedMealIndex;

  List<Meal> getMealsFor(DateTime date, String mealType) {
    final dateKey = '${date.year}-${date.month}-${date.day}';
    if (mealType == '점심') {
      return [
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch1/200',
          vendor: '업체A',
          menu: '불고기덮밥',
          price: '7,000원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch2/200',
          vendor: '업체B',
          menu: '치킨마요',
          price: '6,500원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch3/200',
          vendor: '업체C',
          menu: '제육볶음',
          price: '7,500원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch4/200',
          vendor: '업체D',
          menu: '돈까스',
          price: '8,000원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch5/200',
          vendor: '업체E',
          menu: '비빔밥',
          price: '7,200원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch6/200',
          vendor: '업체F',
          menu: '카레라이스',
          price: '6,800원',
        ),
      ];
    } else {
      return [
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner1/200',
          vendor: '업체G',
          menu: '오므라이스',
          price: '7,300원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner2/200',
          vendor: '업체H',
          menu: '김치볶음밥',
          price: '6,900원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner3/200',
          vendor: '업체I',
          menu: '닭갈비덮밥',
          price: '7,800원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner4/200',
          vendor: '업체J',
          menu: '함박스테이크',
          price: '8,200원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner5/200',
          vendor: '업체K',
          menu: '새우볶음밥',
          price: '7,400원',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner6/200',
          vendor: '업체L',
          menu: '참치마요',
          price: '6,700원',
        ),
      ];
    }
  }

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('주문예약이 완료되었습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = getMealsFor(selectedDate, selectedMeal);
    return Column(
      children: [
        DatePickerBar(
          initialDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              selectedMealIndex = null;
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
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
                onTap: () {
                  setState(() {
                    selectedMeal = '점심';
                    selectedMealIndex = null;
                  });
                },
              ),
              _SelectButton(
                text: '저녁',
                selected: selectedMeal == '저녁',
                onTap: () {
                  setState(() {
                    selectedMeal = '저녁';
                    selectedMealIndex = null;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MealCardList(
          selectedIndex: selectedMealIndex,
          onMealSelected: (index) {
            setState(() {
              selectedMealIndex = index;
            });
          },
          meals: meals,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey.shade300;
                  }
                  return Colors.blue;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.black38;
                  }
                  return Colors.white;
                }),
              ),
              onPressed: selectedMealIndex != null ? _showOrderDialog : null,
              child: Text(
                '도시락 주문하기',
                style: TextStyle(
                  fontWeight:
                      selectedMealIndex != null
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
