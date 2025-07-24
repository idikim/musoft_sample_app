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
              const Text(
                '''안녕하세요, [학원명]입니다.
2025학년도 대비를 위한 하반기 모의고사 테스트가 아래와 같이 실시될 예정이오니, 학생 여러분은 빠짐없이 참여해 실전 감각을 점검하시기 바랍니다.
        
✅ 모의고사 일정
- 일시: 2025년 9월 7일(일) 오전 9시 ~ 오후 4시
- 대상: 고3 재학생 및 N수생 전원
- 장소: [학원 내 지정 고사장 / 각 반별 강의실]
- 과목: 국어, 수학, 영어, 탐구 (선택과목 기준)

📝 응시 안내
- 시험 당일 오전 8시 40분까지 등원 완료 바랍니다.
- 컴퓨터용 사인펜, 수정테이프, 신분증 등 개인 필기도구 지참 필수
- 교실 배정은 시험 당일 오전에 공지됩니다.
- 성적 결과는 시험 후 일주일 이내에 개별 안내 예정입니다.

📌 유의사항
- 시험 당일 지각 및 무단 결시 시 재응시 불가합니다.
- 외부 응시자는 사전 신청 필수이며, 신청 마감은 8월 31일(토) 입니다.
- 고사 중 부정행위 적발 시 해당 시험은 무효 처리됩니다.

실전처럼 준비하여 최상의 컨디션으로 임해주시기 바랍니다.  기타 문의사항은 데스크 또는 담임선생님께 문의해주세요. 감사합니다.''',
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
