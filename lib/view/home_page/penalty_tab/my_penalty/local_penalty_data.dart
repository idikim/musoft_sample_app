import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/model/penalty_category.dart';

List<Penalty> getPenaltiesForMonth(int month) {
  final allPenalties = [
    Penalty(
      id: '1',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 7, 10, 9, 11),
      submittedAt: DateTime(2025, 7, 10, 9, 15),
      approvalDateTime: DateTime(2025, 7, 10, 10, 0),
    ),
    Penalty(
      id: '2',
      description: '과제 미제출',
      status: '승인대기',
      points: 10,
      category: PenaltyCategory.learningAttitude,
      createdAt: DateTime(2025, 7, 15, 14, 25),
      submittedAt: DateTime(2025, 7, 15, 14, 30),
    ),
    Penalty(
      id: '3',
      description: '수업 태도 불량',
      status: '승인완료',
      points: 3,
      category: PenaltyCategory.learningAttitude,
      createdAt: DateTime(2025, 6, 20, 11, 5),
      submittedAt: DateTime(2025, 6, 20, 11, 10),
      approvalDateTime: DateTime(2025, 6, 20, 12, 0),
    ),
    Penalty(
      id: '4',
      status: '승인대기',
      points: 20,
      category: PenaltyCategory.outing,
      createdAt: DateTime(2025, 7, 25, 8, 30),
      submittedAt: DateTime(2025, 7, 25, 8, 35),
    ),
    Penalty(
      id: '5',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 3, 5, 10, 0),
      submittedAt: DateTime(2025, 3, 5, 10, 5),
      approvalDateTime: DateTime(2025, 3, 5, 11, 0),
    ),
    Penalty(
      id: '6',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 9, 5, 13, 45),
      submittedAt: DateTime(2025, 9, 5, 13, 50),
      approvalDateTime: DateTime(2025, 9, 5, 14, 0),
    ),
    Penalty(
      id: '7',
      description: '지각',
      status: '승인대기',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 1, 5, 9, 20),
      submittedAt: DateTime(2025, 1, 5, 9, 25),
    ),
    Penalty(
      id: '8',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 12, 5, 16, 10),
      submittedAt: DateTime(2025, 12, 5, 16, 15),
      approvalDateTime: DateTime(2025, 12, 5, 17, 0),
    ),
    Penalty(
      id: '9',
      description: '지각',
      status: '승인대기',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 3, 5, 10, 5),
      submittedAt: DateTime(2025, 3, 5, 10, 10),
    ),
    Penalty(
      id: '10',
      description: '벌점 사유 미제출',
      points: 10,
      category: PenaltyCategory.learningAttitude,
      createdAt: DateTime(2025, 7, 24, 10, 0),
    ),
  ];

  List<Penalty> filteredList;
  if (month == 0) {
    filteredList = allPenalties;
  } else {
    filteredList =
        allPenalties.where((p) => p.createdAt.month == month).toList();
  }

  filteredList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return filteredList;
}
