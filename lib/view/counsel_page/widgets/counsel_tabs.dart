
import 'package:flutter/material.dart';

class CounselTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CounselTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(0, '상담일지'),
          _buildTabItem(1, '오프라인 QA'),
          _buildTabItem(2, '온라인 QA'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.blue : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
