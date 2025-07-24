import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/notice.dart';

class NoticeDetailPage extends StatelessWidget {
  final Notice notice;
  final VoidCallback onBack;

  const NoticeDetailPage({
    super.key,
    required this.notice,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text('공지사항'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                child: Text(
                  notice.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                notice.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                DateFormat('yyyy-MM-dd').format(notice.date),
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              Text(
                notice.content,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Center(child: Text('목록보기')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
