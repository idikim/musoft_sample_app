import 'package:flutter/material.dart';

class TabStrings {
  static const List<String> topTabs = ['홈', '공지사항', '도시락', '상점', '벌점'];
}

class HomeTabs extends StatelessWidget {
  final List<String> topTabs;
  final int topTabIndex;
  final ValueChanged<int> onTopTabChanged;
  final VoidCallback? onNotificationTap;

  const HomeTabs({
    super.key,
    required this.topTabs,
    required this.topTabIndex,
    required this.onTopTabChanged,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(topTabs.length, (i) {
                return GestureDetector(
                  onTap: () => onTopTabChanged(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border:
                          topTabIndex == i
                              ? const Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Colors.blueAccent,
                                ),
                              )
                              : null,
                    ),
                    child: Text(
                      topTabs[i],
                      style: TextStyle(
                        color:
                            topTabIndex == i ? Colors.blueAccent : Colors.black,
                        fontWeight:
                            topTabIndex == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: const Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
