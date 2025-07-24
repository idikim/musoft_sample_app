import 'package:madezone_study_student_app/model/penalty.dart';

List<Penalty> getPenaltiesForMonth(int month) {
  final allPenalties = [
    Penalty(
      date: DateTime(2025, 7, 10, 9, 11),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인완료',
    ),
    Penalty(
      date: DateTime(2025, 7, 15, 14, 25),
      reason: '과제 미제출',
      points: 10,
      category: '학습',
      status: '승인대기',
    ),
    Penalty(
      date: DateTime(2025, 6, 20, 11, 5),
      reason: '수업 태도 불량',
      points: 3,
      category: '학습태도',
      status: '승인완료',
    ),
    Penalty(
      date: DateTime(2025, 7, 25, 8, 30),
      points: 20,
      category: '외출',
      status: '승인대기',
    ),
    Penalty(
      date: DateTime(2025, 3, 5, 10, 0),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인완료',
    ),
    Penalty(
      date: DateTime(2025, 9, 5, 13, 45),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인완료',
    ),
    Penalty(
      date: DateTime(2025, 1, 5, 9, 20),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인대기',
    ),
    Penalty(
      date: DateTime(2025, 12, 5, 16, 10),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인완료',
    ),
    Penalty(
      date: DateTime(2025, 3, 5, 10, 5),
      reason: '지각',
      points: 5,
      category: '생활',
      status: '승인대기',
    ),
  ];

  List<Penalty> filteredList;
  if (month == 0) {
    filteredList = allPenalties;
  } else {
    filteredList = allPenalties.where((p) => p.date.month == month).toList();
  }

  filteredList.sort((a, b) => a.date.compareTo(b.date));
  return filteredList;
}
