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
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '학습관리'),
    BottomNavigationBarItem(icon: Icon(Icons.house), label: '생활관리'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: '상담'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
  ];

  static List<BottomNavigationBarItem> get bottomTabs => _bottomTabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _bottomTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
    );
  }
}
