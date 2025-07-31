import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPatrolResultPage extends StatefulWidget {
  const MyPatrolResultPage({super.key});

  @override
  State<MyPatrolResultPage> createState() => _MyPatrolResultPageState();
}

class _MyPatrolResultPageState extends State<MyPatrolResultPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double size) => size * width / 440;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘의 순찰결과',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(DateFormat('M월 d일').format(selectedDate)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text('오전'),
          Column(
            children: List.generate(
              3,
              (rowIdx) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (colIdx) => Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text('06:20', style: TextStyle(fontSize: scale(14))),
                        Icon(Icons.face, size: scale(24)),
                        Text('공부중', style: TextStyle(fontSize: scale(12))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
