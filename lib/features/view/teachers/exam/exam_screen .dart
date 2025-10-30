import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/local/localdata.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/add_exam_sreens.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/exam_details.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllExamScreen extends StatefulWidget {
  const AllExamScreen({super.key});

  @override
  State<AllExamScreen> createState() => _AllExamScreenState();
}

class _AllExamScreenState extends State<AllExamScreen> {
 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<ExamProvider>(context, listen: false).fetchExams();
  });
}

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
      body: Consumer<ExamProvider>(
        builder: (BuildContext context, ExamProvider state, Widget? child) {
          if (state.isLoading) {
            // Show loading spinner while fetching
            return const Center(child: CircularProgressIndicator());
          }

          if (state.allExams.isEmpty) {
            // Show placeholder if list is empty
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room, size: 60, color: AppColors.grey),
                  const SizedBox(height: 12),
                  Text(
                    "No rooms available",
                    style: TextStyle(fontSize: 16, color: AppColors.textColor),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
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
                  itemCount: state.allExams.length,
                  itemBuilder: (context, index) {
                    final data = state.allExams[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamDetailScreen(exam: data,),
                            ),
                          );
                        },
                        child: MainFrame(
                          examName: data.courseName,
                          examCode: data.courseId,
                          time: data.startTime,
                          sem: data.sem,
                          
                          onUpdate: () {
                            state.setExamForUpdate(data);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddExamScreens(exam: data),
                              ),
                            );
                          },
                          onDelete: () {
                            state.deleteExam(data.examId!);
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
