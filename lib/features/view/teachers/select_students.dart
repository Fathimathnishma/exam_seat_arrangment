// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bca_exam_managment/features/view/local/localdata.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/room_viewodel.dart';

class SelectExamDemo extends StatefulWidget {
  final String roomId;
  const SelectExamDemo({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  State<SelectExamDemo> createState() => _SelectExamDemoState();
}

class _SelectExamDemoState extends State<SelectExamDemo> {
  final TextEditingController _examController = TextEditingController();
  final TextEditingController _to = TextEditingController();

  bool _showDropdown = false;
  ExamModel? selectedExam;

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
      appBar: AppBar(title: const Text('Select Exam')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<ExamProvider, RoomProvider>(
          builder: (context, examState, roomState, child) {
           RoomModel? room = roomState.allRooms
    .cast<RoomModel?>()
    .firstWhere((r) => r?.id == widget.roomId, orElse: () => null);


            int assignedCount = 0;
            if (selectedExam != null && room != null) {
            assignedCount = selectedExam!.students.length - selectedExam!.duplicatestudents.length;
                
            }

            return Column(
              children: [
                // 🔹 Exam selection field
                TextFormField(
                  controller: _examController,
                  decoration: const InputDecoration(
                    hintText: 'Select Exam',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  readOnly: true,
                  onTap: () {
                    setState(() => _showDropdown = !_showDropdown);
                  },
                ),

                // 🔹 Dropdown list
                if (_showDropdown)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: examState.allExams.length,
                      itemBuilder: (context, index) {
                        final exam = examState.allExams[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _examController.text = exam.courseName;
                              selectedExam = exam;
                              setState(() => _showDropdown = false);
                            },
                            child: MainFrame(
                              examName: exam.courseName,
                              examCode: exam.courseId,
                              time: exam.startTime,
                              sem: exam.sem,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                    ),
                  ),

                const SizedBox(height: 20),

                // 🔹 From and To fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'From',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _to,
                        decoration: const InputDecoration(
                          hintText: 'To',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Display counts
                if (selectedExam != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Students: ${selectedExam!.students.length }",
                      ),
                      Text(
                        "Assigned: $assignedCount",
                      ),
                      Text(
                        "Remaining: ${((selectedExam!.students.length ) - assignedCount)}",
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                // 🔹 Save button
                InkWell(
                  onTap: () async {
                    if (selectedExam != null) {
                      await roomState.AddExamtoList(
                        widget.roomId,
                        selectedExam!.examId!,
                      );
                       if (selectedExam!.duplicatestudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "❌ Cannot assign this exam. No students available to assign.",
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

                      
                      await roomState.assignStudentsToRoom(
                        exam: selectedExam!,
                        roomId: widget.roomId,
                        count: int.tryParse(_to.text) ?? 10,
                      );

                      Fluttertoast.showToast(
                        msg: "Exam and students assigned successfully ✅",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Select an exam first",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 45,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
