import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/local/localdata.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/exam_details.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:flutter/material.dart';

class AllExamScreen extends StatefulWidget {
  const AllExamScreen({super.key});

  @override
  State<AllExamScreen> createState() => _AllExamScreenState();
}

class _AllExamScreenState extends State<AllExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "All Exams",
          //textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search any Product..',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 19,
                          color: AppColors.white,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        fillColor: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    height: 46,
                    width: MediaQuery.sizeOf(context).width * 0.12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Image.asset(AppImages.filter),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamDetailScreen(),
                        ),
                      );
                    },
                    child: MainFrame(
                      examName: exams[index]["examName"]!,
                      examCode: exams[index]["examCode"]!,
                      time: exams[index]["time"]!,
                      sem: exams[index]["sem"]!,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 5),
            ),
          ],
        ),
      ),
    );
  }
}
