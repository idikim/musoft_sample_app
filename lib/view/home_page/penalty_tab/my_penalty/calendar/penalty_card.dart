import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/penalty.dart';

class PenaltyCard extends StatelessWidget {
  final Penalty penalty;
  final VoidCallback onTap;
  const PenaltyCard({required this.penalty, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        width: double.infinity,
        color: Colors.red.shade50,
        child: Row(
          children: [
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-${penalty.points}점',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  penalty.category.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
