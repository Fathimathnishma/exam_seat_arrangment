import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/exam_details.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart' show AuthProvider;
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeProvider.startDateTimeStream();
      await examProvider.fetchExams();
      examProvider.getTodayExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ExamProvider>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header
              Container(
                height: MediaQuery.sizeOf(context).height * 0.22,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 12, right: 12, bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                           CircleAvatar(
                            radius: 23,
                           backgroundImage:AssetImage(AppImages.Defaultprofile),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            auth.currentUser?.name??"",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        onChanged: state.onTodaySearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search exams..',
                          hintStyle: const TextStyle(fontSize: 12),
                          prefixIcon:
                              const Icon(Icons.search, size: 19),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info cards
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                      stream: homeProvider.dateTimeStream,
                      builder: (context, snapshot) {
                        return _buildInfoCard(
                          title: homeProvider.formattedDate,
                          value: homeProvider.formattedTime,
                        );
                      },
                    ),
                    _buildInfoCard(
                      title: "Exams Today",
                      value: state.todaysExams.length.toString(),
                    ),
                  ],
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  "Today Exams",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Exam list or empty state
              if (state.todaysExams.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Column(
                      children: [
                        // Optional: Image.asset(AppImages.noData, height: 120),
                        const SizedBox(height: 10),
                        Text(
                          "No exams scheduled for today",
                          style: TextStyle(
                            color: AppColors.textColor.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...state.todaysExams.map((data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 7.5),
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
                        visibleMenu: false,
                      ),
                    ),
                  );
                }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    String? value,
  }) {
    return Container(
      height: 84,
      width: MediaQuery.sizeOf(context).width * 0.44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
