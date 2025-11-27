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
        automaticallyImplyLeading: false,
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
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 🔍 SEARCH + FILTER ROW
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

                    // 📅 FILTER BUTTON
                    GestureDetector(
                      onTap: () => _openFilterSheet(context),
                      child: Container(
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
                    ),
                  ],
                ),
              ),

              // 🗂 NO DATA OR LIST
              if (state.filteredExams.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      state.searchText.isNotEmpty
                          ? "No matching Exam found"
                          : "No Exam available...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
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
                              state.deleteExam(data);
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

  // 📅 FILTER SHEET
  void _openFilterSheet(BuildContext context) {
    final state = Provider.of<ExamProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filter Exams By Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // SINGLE DATE
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Select Single Date"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    state.filterBySingleDate(picked);
                    Navigator.pop(context);
                  }
                },
              ),

              // DATE RANGE
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Select Date Range"),
                onTap: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (range != null) {
                    state.filterByRange(range.start, range.end);
                    Navigator.pop(context);
                  }
                },
              ),

              // CLEAR FILTER
              if (state.selectedDate != null || state.selectedRange != null)
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text("Clear Filters"),
                  onTap: () {
                    state.resetFilter();
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
