import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madezone_study_student_app/model/penalty.dart';
import 'package:madezone_study_student_app/view/home_page/penalty_tab/submission/submission_page.dart';

class ItemMyPenalty extends StatelessWidget {
  final Penalty penalty;
  final ValueChanged<Penalty> onPenaltySelected;

  const ItemMyPenalty({
    super.key,
    required this.penalty,
    required this.onPenaltySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '-${penalty.points}점',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        penalty.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      penalty.status ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(penalty.description ?? ''),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (penalty.status == null) {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const SubmissionPage(),
                        ),
                      );
                    } else {
                      onPenaltySelected(penalty);
                    }
                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color:
                          penalty.status == null
                              ? Colors.black
                              : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        penalty.status == null ? '사유 제출하기' : '상세보기',
                        style: TextStyle(
                          color:
                              penalty.status == null
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  DateFormat('a hh:mm', 'ko_KR').format(penalty.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
