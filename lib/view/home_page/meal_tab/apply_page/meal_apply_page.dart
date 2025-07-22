import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/date_picker_bar.dart';
import 'widgets/meal_card_list.dart';
import 'meal_sample_data.dart';

class MealApplyPage extends StatefulWidget {
  const MealApplyPage({super.key});

  @override
  State<MealApplyPage> createState() => _MealApplyPageState();
}

class _MealApplyPageState extends State<MealApplyPage> {
  DateTime selectedDate = DateTime.now();
  String selectedMeal = '점심';
  int? selectedMealIndex;

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
                  child: _AnimatedTapScale(
                    onTap: selectedMealIndex != null ? _showOrderDialog : null,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          selectedMealIndex != null
                              ? Colors.blueAccent
                              : Colors.black26,
                        ),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        elevation: WidgetStatePropertyAll(
                          selectedMealIndex != null ? 8 : 0,
                        ),
                        shadowColor: WidgetStatePropertyAll(
                          selectedMealIndex != null
                              ? Colors.black.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      ),
                      onPressed: null,
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
  bool get _isEnabled => widget.onTap != null;

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) {
      setState(() {
        _scale = 0.95;
      });
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (_isEnabled) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _scale = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 50));
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (_isEnabled) {
      setState(() {
        _scale = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isEnabled ? _onTapDown : null,
      onTapUp: _isEnabled ? _onTapUp : null,
      onTapCancel: _isEnabled ? _onTapCancel : null,
      child: AnimatedScale(
        scale: _isEnabled ? _scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
