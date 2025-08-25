import 'package:flutter/material.dart';
import 'package:bca_exam_managment/core/utils/app_colors.dart';

class MainFrame extends StatefulWidget {
  final String examName;
  final String examCode;
  final String time;
  final String sem;

  const MainFrame({
    super.key,
    required this.examName,
    required this.examCode,
    required this.time,
    required this.sem,
  });

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 129,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(color: AppColors.grey, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.examName,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "examCode: ${widget.examCode}",
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
            Text(
              "Semester: ${widget.sem}",
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),

            Text(
              "Duration: ${widget.time}",
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
