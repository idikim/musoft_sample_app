import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musoft_sample_app/model/meal.dart';
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
          menu: '불고기덮밥',
          description: '고소한 불고기와 밥이 어우러진 한 그릇 요리',
          price: '7,000',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch2/200',
          menu: '치킨마요',
          description: '닭고기와 마요네즈의 조화, 인기 메뉴',
          price: '6,500',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch3/200',
          menu: '제육볶음',
          description: '매콤한 돼지고기 볶음과 밥',
          price: '7,500',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch4/200',
          menu: '돈까스',
          description: '바삭한 돈까스와 특제 소스',
          price: '8,000',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch5/200',
          menu: '비빔밥',
          description: '다양한 나물과 고추장이 어우러진 비빔밥',
          price: '7,200',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}lunch6/200',
          menu: '카레라이스',
          description: '진한 카레와 밥의 만남',
          price: '6,800',
        ),
      ];
    } else {
      return [
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner1/200',
          menu: '오므라이스',
          description: '계란으로 감싼 볶음밥',
          price: '7,300',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner2/200',
          menu: '김치볶음밥',
          description: '매콤한 김치와 밥의 조화',
          price: '6,900',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner3/200',
          menu: '닭갈비덮밥',
          description: '매콤한 닭갈비와 밥',
          price: '7,800',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner4/200',
          menu: '함박스테이크',
          description: '두툼한 함박스테이크와 소스',
          price: '8,200',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner5/200',
          menu: '새우볶음밥',
          description: '탱글한 새우와 볶음밥',
          price: '7,400',
        ),
        Meal(
          imageUrl: 'https://picsum.photos/seed/${dateKey}dinner6/200',
          menu: '참치마요',
          description: '참치와 마요네즈의 고소함',
          price: '6,700',
        ),
      ];
    }
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
                  setState(() {
                    selectedMealIndex = null;
                  });
                },
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
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
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(color: Colors.black12),
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Expanded(
                  child: MealCardList(
                    selectedIndex: selectedMealIndex,
                    onMealSelected: (index) {
                      setState(() {
                        selectedMealIndex = index;
                      });
                    },
                    meals: meals,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.black12)),
                  ),
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.black26;
                        }
                        return Colors.blueAccent;
                      }),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      elevation: WidgetStateProperty.resolveWith<double?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return 0;
                        }
                        return 8;
                      }),
                      shadowColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.transparent;
                        }
                        return Colors.black.withOpacity(0.3);
                      }),
                    ),
                    onPressed:
                        selectedMealIndex != null ? _showOrderDialog : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '도시락 주문하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
