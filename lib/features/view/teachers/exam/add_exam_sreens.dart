import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/service.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExamScreens extends StatelessWidget {
  final ExamModel? exam; // null = add, not null = update

  const AddExamScreens({super.key, this.exam});

  @override
  Widget build(BuildContext context) {
    final blueBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.primary, width: 1),
    );

    final _formKey = GlobalKey<FormState>();

    void showSnackBar(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        actions: [SizedBox(width: 40)],
        title: Center(
          child: Text(
            exam == null ? "Add Exam" : "Update Exam",
            style: TextStyle(
              fontWeight: FontWeight.w600,
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
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
      ),
      body: Consumer<ExamProvider>(
        builder: (context, state, child) {
          // initialize data if updating
          // if (exam != null && state.examNameController.text.isEmpty) {
          //   state.loadExam(exam!);
          // }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Course Name
                      TextFormField(
                        controller: state.examNameController,
                        decoration: InputDecoration(
                          hintText: 'Course Name:',
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Course name is required'
                                    : null,
                      ),
                      SizedBox(height: 12),

                      // Exam Code (full row)
                      TextFormField(
                        controller: state.courseIdController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Exam Code:',
                          border: blueBorder,
                          enabledBorder: blueBorder,
                          focusedBorder: blueBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Exam code is required'
                                    : null,
                      ),
                      SizedBox(height: 12),

         // Department & Semester
Row(
  children: [
    Expanded(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: blueBorder,
          enabledBorder: blueBorder,
          focusedBorder: blueBorder,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        ),
        value: state.selectedDepartment,
        hint: Text('Department', style: TextStyle()),
        items: state.departments
            .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
            .toList(),
        onChanged: state.setDepartment,
        validator: (value) =>
            value == null || value.isEmpty ? 'Department required' : null,
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: blueBorder,
          enabledBorder: blueBorder,
          focusedBorder: blueBorder,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        ),
        value: state.selectedSem,
        hint: Text('Semester',  ),
        items: state.semesters
            .map((sem) => DropdownMenuItem(value: sem, child: Text(sem)))
            .toList(),
        onChanged: state.setSemester,
        validator: (value) =>
            value == null || value.isEmpty ? 'Semester required' : null,
      ),
    ),
  ],
),


                      SizedBox(height: 12),

                      // Date
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            state.dateController.text =
                                "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                            state.selectedDate = pickedDate;
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: state.dateController,
                            decoration: InputDecoration(
                              hintText: 'Date',
                              border: blueBorder,
                              enabledBorder: blueBorder,
                              focusedBorder: blueBorder,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Start Time & Ending Time
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  state.timeController.text = pickedTime.format(
                                    context,
                                  );
                                }
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: state.timeController,
                                  decoration: InputDecoration(
                                    hintText: 'Start Time',
                                    border: blueBorder,
                                    enabledBorder: blueBorder,
                                    focusedBorder: blueBorder,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final pickedEndTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedEndTime != null) {
                                  state.endTimeController.text = pickedEndTime
                                      .format(context);
                                }
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: state.endTimeController,
                                  decoration: InputDecoration(
                                    hintText: 'Ending Time',
                                    border: blueBorder,
                                    enabledBorder: blueBorder,
                                    focusedBorder: blueBorder,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Add Students List",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Upload & Save Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
        onTap: () async {
  // Show loading dialog (optional but recommended for better UX)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Parsing file...'),
        ],
      ),
    ),
  );

  try {
    // Pick and parse file
    final loadedStudents = await StudentFileParser.pickAndParseFile(context);

    // Dismiss loading dialog
    if (context.mounted) Navigator.of(context).pop();  // Close dialog

    if (loadedStudents.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No valid students found. Ensure file has required columns: Name, RegNo, Department, Semester.')),
        );
      }
      return;
    }

    // Add students directly to provider state
    state.clearStudents();  // Optional: clear previous list
    state.addStudents(loadedStudents);

    // Show feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loadedStudents.length} students loaded successfully!'),
          backgroundColor: Colors.green,  // Visual success
        ),
      );
    }
  } catch (e) {
    // Dismiss loading if still open
    if (context.mounted) Navigator.of(context).pop();
    
    // Error feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    print('onTap error: $e');  // Log for debugging (check Android Logcat)
  }
},
                            child: Container(
                              height: 44,
                              width: 157,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Upload File",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Image.asset(
                                    AppImages.upload,
                                    height: 28,
                                    width: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (state.students.isEmpty) {
                                  showSnackBar("Student list cannot be empty");
                                  return;
                                }
                                if (exam == null) {
                                  await state.addExam();
                                  showSnackBar("Exam saved successfully!");
                                  
                                }
                                else {
                                  await state.updateExam();
                                  showSnackBar("Exam updated successfully!");
                                }
                                
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                exam == null ? "Save" : "Update",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Text(
                        "Total Students: ${state.students.length}",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
 }
