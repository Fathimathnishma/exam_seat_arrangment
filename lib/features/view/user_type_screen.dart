import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/student/students_entry_Screen.dart';
import 'package:bca_exam_managment/features/view/teachers/teacher_login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //  Gap(70),
            Text(
              "Select Login Role",
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontWeight: FontWeight.w500,
                fontSize: 26,
                color: AppColors.textColor,
              ),
            ),

            // Gap(150),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherLoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 223,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(AppImages.teacher),
                                // SizedBox(height: 10),
                                Text(
                                  "Teacher",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // spacing between the two containers
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentsLoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 223,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(AppImages.student),
                                //  SizedBox(height: 10),
                                Text(
                                  "Student",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(18),
                Text(
                  "Choose your login type to enter\n the seat allocation system.",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // SizedBox(height: 31),
            Gap(100),
          ],
        ),
      ),
    );
  }
}
