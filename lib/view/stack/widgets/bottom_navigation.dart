import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavigationBarItem> _bottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      label: '학습관리',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.house_outlined), label: '생활관리'),
    BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: '상담'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
  ];

  static List<BottomNavigationBarItem> get bottomTabs => _bottomTabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1, thickness: 1, color: Colors.black12),
        BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          items: _bottomTabs,
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ],
    );
  }
}
