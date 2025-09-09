import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/local/localdata.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:flutter/material.dart';

class ExamDetailScreen extends StatefulWidget {
  const ExamDetailScreen({super.key});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,

        title: Center(
          child: Text(
            "Exam details",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.textColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(color: AppColors.textColor, blurRadius: 1),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Exam Name:Computer Apllications',
                    style: TextStyle(color: AppColors.textColor, fontSize: 14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Date:20/11/2025',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Time:9:00AM to 11:00Am',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' Room no:AD123',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // spacing between dropdowns
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' Semester:First',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Duration:2 hrs',
                    style: TextStyle(color: AppColors.textColor, fontSize: 14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Department:Computer Apllications',
                    style: TextStyle(color: AppColors.textColor, fontSize: 14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Rooms", style: TextStyle(fontSize: 20)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  return MainFrame(
                    examName: exams[index]["examName"]!,
                    examCode: exams[index]["examCode"]!,
                    time: exams[index]["time"]!,
                    sem: exams[index]["sem"]!,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
