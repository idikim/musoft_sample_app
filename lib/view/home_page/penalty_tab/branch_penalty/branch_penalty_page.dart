import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/branch_penalty/branch_penalty_card.dart';

class BranchPenaltyPage extends StatelessWidget {
  const BranchPenaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '광진점',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '우리 지점의 벌점 분포 현황을 확인해보세요',
                  style: TextStyle(color: Colors.black45),
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 8,
                  children: [
                    BranchPenaltyCard(
                      penaltyPoints: '0점',
                      numberOfStudents: '68',
                      topIcon: Icons.favorite_rounded,
                      topIconColor: Colors.green,
                      bottomIcon: Icons.face,
                      bottomText: '아주 잘하고있어요!',
                      bottomTextColor: Colors.green,
                    ),

                    BranchPenaltyCard(
                      penaltyPoints: '0점 이상',
                      numberOfStudents: '1',
                      topIcon: Icons.warning_rounded,
                      topIconColor: Colors.amber,
                      bottomIcon: Icons.face,
                      bottomText: '조금 주의해볼까요?',
                      bottomTextColor: Colors.orange,
                    ),

                    BranchPenaltyCard(
                      penaltyPoints: '10점 이상',
                      numberOfStudents: '68',
                      topIcon: Icons.back_hand_rounded,
                      topIconColor: Colors.red,
                      bottomIcon: Icons.face,
                      bottomText: '벌점에 유의하세요',
                      bottomTextColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
