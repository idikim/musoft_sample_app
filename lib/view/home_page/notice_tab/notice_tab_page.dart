import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/notice.dart';

class HomeTabNoticePage extends StatelessWidget {
  final Function(Notice) onNoticeSelected;

  HomeTabNoticePage({super.key, required this.onNoticeSelected});

  final List<Notice> _notices = [
    Notice(title: '2025 하반기 모의고사 테스트 안내', date: DateTime(2024, 7, 26), category: '공지'),
    Notice(title: '월간 모의평가 일정 공지', date: DateTime(2024, 7, 25), category: '공지'),
    Notice(title: '1:1 채팅 시 주의사항 필수 지침서', date: DateTime(2024, 7, 20), category: '공지'),
    Notice(title: '자습실 공사 안내 일정', date: DateTime(2024, 7, 15), category: '공지'),
    Notice(title: '2025 하반기 모의고사 테스트 안내', date: DateTime(2024, 7, 26), category: '공지'),
    Notice(title: '월간 모의평가 일정 공지', date: DateTime(2024, 7, 25), category: '공지'),
    Notice(title: '1:1 채팅 시 주의사항 필수 지침서', date: DateTime(2024, 7, 20), category: '공지'),
    Notice(title: '자습실 공사 안내 일정', date: DateTime(2024, 7, 15), category: '공지'),
    Notice(title: '2025 하반기 모의고사 테스트 안내', date: DateTime(2024, 7, 26), category: '공지'),
    Notice(title: '월간 모의평가 일정 공지', date: DateTime(2024, 7, 25), category: '공지'),
    Notice(title: '1:1 채팅 시 주의사항 필수 지침서', date: DateTime(2024, 7, 20), category: '공지'),
    Notice(title: '자습실 공사 안내 일정', date: DateTime(2024, 7, 15), category: '공지'),
    Notice(title: '2025 하반기 모의고사 테스트 안내', date: DateTime(2024, 7, 26), category: '공지'),
    Notice(title: '월간 모의평가 일정 공지', date: DateTime(2024, 7, 25), category: '공지'),
    Notice(title: '1:1 채팅 시 주의사항 필수 지침서', date: DateTime(2024, 7, 20), category: '공지'),
    Notice(title: '자습실 공사 안내 일정', date: DateTime(2024, 7, 15), category: '공지'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _notices.length,
      itemBuilder: (context, index) {
        final notice = _notices[index];
        return InkWell(
          splashColor: Colors.transparent,
          onTap: () => onNoticeSelected(notice),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        '공지',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            DateFormat('yyyy-MM-dd').format(notice.date),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                height: 1,
                color: Colors.black12,
              ),
            ],
          ),
        );
      },
    );
  }
}
