import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhoneSubmissionPage extends StatefulWidget {
  const PhoneSubmissionPage({super.key});

  @override
  State<PhoneSubmissionPage> createState() => _PhoneSubmissionPageState();
}

class _PhoneSubmissionPageState extends State<PhoneSubmissionPage> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.black12,
                        child: Text('보관함 번호 58'),
                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
