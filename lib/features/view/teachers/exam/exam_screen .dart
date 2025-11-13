import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
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
        automaticallyImplyLeading: false, // ✅ Removes default back button
        backgroundColor: AppColors.white,
        title: Text(
          "All Exams",
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
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ✅ Always visible search bar
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: state.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search exam...',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 19,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: AppColors.primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
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
                        padding: const EdgeInsets.all(13.0),
                        child: Image.asset(AppImages.filter),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Exam list or no data message
              if (state.filteredExams.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.noData, height: 50, width: 50),
                        const SizedBox(height: 12),
                        Text(
                          state.searchText.isNotEmpty
                              ? "No matching Exam found"
                              : "No Exam available...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: state.filteredExams.length,
                    itemBuilder: (context, index) {
                      final data = state.filteredExams[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExamDetailScreen(exam: data),
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
                                  builder: (context) =>
                                      AddExamScreens(exam: data),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
