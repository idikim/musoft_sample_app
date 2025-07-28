import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/model/penalty_category.dart';
import 'package:madezone_study_student_app/model/penalty_reason.dart';

List<Penalty> getPenaltiesForMonth(int month) {
  final allPenalties = [
    Penalty(
      id: '1',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 7, 10, 9, 11),
      isReasonSubmitted: true,
      approvalDateTime: DateTime(2025, 7, 10, 10, 0),
    ),
    Penalty(
      id: '2',
      description: '과제 미제출',
      points: 10,
      category: PenaltyCategory.learningAttitude,
      createdAt: DateTime(2025, 7, 15, 14, 25),
    ),
    Penalty(
      id: '3',
      description: '수업 태도 불량',
      status: '승인완료',
      points: 3,
      category: PenaltyCategory.learningAttitude,
      createdAt: DateTime(2025, 6, 20, 11, 5),
      isReasonSubmitted: true,
      approvalDateTime: DateTime(2025, 6, 20, 12, 0),
    ),
    Penalty(
      id: '4',
      status: '승인대기',
      points: 20,
      category: PenaltyCategory.outing,
      createdAt: DateTime(2025, 7, 25, 8, 30),
      isReasonSubmitted: true,
    ),
    Penalty(
      id: '5',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 3, 5, 10, 0),
      isReasonSubmitted: true,
      approvalDateTime: DateTime(2025, 3, 5, 11, 0),
    ),
    Penalty(
      id: '6',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 9, 5, 13, 45),
      isReasonSubmitted: true,
      approvalDateTime: DateTime(2025, 9, 5, 14, 0),
    ),
    Penalty(
      id: '7',
      description: '지각',
      status: '승인대기',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 1, 5, 9, 20),
      isReasonSubmitted: true,
    ),
    Penalty(
      id: '8',
      description: '지각',
      status: '승인완료',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 12, 5, 16, 10),
      isReasonSubmitted: true,
      approvalDateTime: DateTime(2025, 12, 5, 17, 0),
    ),
    Penalty(
      id: '9',
      description: '지각',
      status: '승인대기',
      points: 5,
      category: PenaltyCategory.tardy,
      createdAt: DateTime(2025, 3, 5, 10, 5),
      isReasonSubmitted: true,
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

List<PenaltyReason> getPenaltyReasonsForMonth(int month) {
  final allPenaltyReasons = [
    PenaltyReason(
      id: '1',
      category: PenaltyCategory.tardy,
      penaltyId: '1',
      startDate: DateTime(2025, 7, 10, 9, 0),
      endDate: DateTime(2025, 7, 10, 9, 11),
      userReason: '교통 체증으로 인한 지각입니다.',
      submittedAt: DateTime(2025, 7, 10, 9, 30),
    ),
    // PenaltyReason(
    //   id: '2',
    //   category: PenaltyCategory.learningAttitude,
    //   penaltyId: '2',
    //   startDate: DateTime(2025, 7, 15, 14, 0),
    //   endDate: DateTime(2025, 7, 15, 14, 25),
    //   userReason: '과제 제출 기한을 착각했습니다.',
    //   submittedAt: DateTime(2025, 7, 15, 15, 0),
    // ),
    PenaltyReason(
      id: '3',
      category: PenaltyCategory.learningAttitude,
      penaltyId: '3',
      startDate: DateTime(2025, 6, 20, 11, 0),
      endDate: DateTime(2025, 6, 20, 11, 5),
      userReason: '수업 중 잠시 졸았습니다.',
      submittedAt: DateTime(2025, 6, 20, 11, 30),
    ),
    PenaltyReason(
      id: '4',
      category: PenaltyCategory.outing,
      penaltyId: '4',
      startDate: DateTime(2025, 7, 25, 8, 0),
      endDate: DateTime(2025, 7, 25, 8, 30),
      userReason: '개인 사정으로 인한 외출입니다.',
      submittedAt: DateTime(2025, 7, 25, 9, 0),
    ),
    PenaltyReason(
      id: '5',
      category: PenaltyCategory.tardy,
      penaltyId: '5',
      startDate: DateTime(2025, 3, 5, 9, 50),
      endDate: DateTime(2025, 3, 5, 10, 0),
      userReason: '알람을 듣지 못했습니다.',
      submittedAt: DateTime(2025, 3, 5, 10, 30),
    ),
    PenaltyReason(
      id: '6',
      category: PenaltyCategory.tardy,
      penaltyId: '6',
      startDate: DateTime(2025, 9, 5, 13, 30),
      endDate: DateTime(2025, 9, 5, 13, 45),
      userReason: '병원 진료로 인해 늦었습니다.',
      submittedAt: DateTime(2025, 9, 5, 14, 15),
    ),
    PenaltyReason(
      id: '7',
      category: PenaltyCategory.tardy,
      penaltyId: '7',
      startDate: DateTime(2025, 1, 5, 9, 0),
      endDate: DateTime(2025, 1, 5, 9, 20),
      userReason: '눈이 많이 와서 길이 막혔습니다.',
      submittedAt: DateTime(2025, 1, 5, 9, 40),
    ),
    PenaltyReason(
      id: '8',
      category: PenaltyCategory.tardy,
      penaltyId: '8',
      startDate: DateTime(2025, 12, 5, 16, 0),
      endDate: DateTime(2025, 12, 5, 16, 10),
      userReason: '개인적인 급한 용무가 있었습니다.',
      submittedAt: DateTime(2025, 12, 5, 16, 30),
    ),
    PenaltyReason(
      id: '9',
      category: PenaltyCategory.tardy,
      penaltyId: '9',
      startDate: DateTime(2025, 3, 5, 10, 0),
      endDate: DateTime(2025, 3, 5, 10, 5),
      userReason: '늦잠을 자서 지각했습니다.',
      submittedAt: DateTime(2025, 3, 5, 10, 30),
    ),
    // PenaltyReason(
    //   id: '10',
    //   category: PenaltyCategory.learningAttitude,
    //   penaltyId: '10',
    //   startDate: DateTime(2025, 7, 24, 9, 50),
    //   endDate: DateTime(2025, 7, 24, 10, 0),
    //   userReason: '벌점 사유 제출을 깜빡했습니다.',
    //   submittedAt: DateTime(2025, 7, 24, 10, 30),
    // ),
  ];

  List<PenaltyReason> filteredList;
  if (month == 0) {
    filteredList = allPenaltyReasons;
  } else {
    filteredList =
        allPenaltyReasons.where((pr) => pr.startDate.month == month).toList();
  }

  filteredList.sort((a, b) => a.startDate.compareTo(b.startDate));
  return filteredList;
}
