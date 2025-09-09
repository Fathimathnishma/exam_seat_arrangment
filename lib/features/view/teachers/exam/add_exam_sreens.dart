import 'dart:io';

import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/service.dart';
import 'package:flutter/material.dart';

class AddExamScreens extends StatefulWidget {
  const AddExamScreens({super.key});

  @override
  State<AddExamScreens> createState() => _AddExamScreensState();
}

class _AddExamScreensState extends State<AddExamScreens> {
  String? selectedDepartment;
  String? selectedSem;

  final departments = ['CSE', 'ECE', 'ME', 'IT'];
  final semesters = ['S1', 'S2', 'S3', 'S4'];

  final blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: AppColors.primary, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Center(
          child: Text(
            "Add Exams ",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Exam Name:',
                  hintStyle: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: blueBorder,
                  enabledBorder: blueBorder,
                  focusedBorder: blueBorder,
                ),
                keyboardType: TextInputType.text,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                        value: selectedSem,
                        hint: Text(
                          'Sem',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                        items:
                            semesters
                                .map(
                                  (sem) => DropdownMenuItem(
                                    value: sem,
                                    child: Text(sem),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => selectedSem = val),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                        value: selectedDepartment,
                        hint: Text(
                          'Department',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                        items:
                            departments
                                .map(
                                  (dept) => DropdownMenuItem(
                                    value: dept,
                                    child: Text(dept),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setState(() => selectedDepartment = val),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          hintText: 'Time',
                          hintStyle: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          hintText: 'Date',
                          hintStyle: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Text(
                  "Add Students List ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final students = await pickFileAndParse(context);
                      if (students.isNotEmpty) {
                        for (var s in students) {
                          debugPrint(s.toString()); // Prints parsed students
                        }
                      }
                    },

                    child: Container(
                      height: 44,
                      width: 157,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.primary, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Upload File",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 17,
                              ),
                            ),
                            Image.asset(AppImages.upload),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
