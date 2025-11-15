// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bca_exam_managment/features/models/student_model.dart';
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
  const SelectExamDemo({Key? key, required this.roomId}) : super(key: key);

  @override
  State<SelectExamDemo> createState() => _SelectExamDemoState();
}

class _SelectExamDemoState extends State<SelectExamDemo> {
  final TextEditingController _examController = TextEditingController();
  final TextEditingController _to = TextEditingController();
  bool _isLoading = false;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer2<ExamProvider, RoomProvider>(
            builder: (context, examState, roomState, child) {
              // Get current room
              RoomModel? room = roomState.allRooms
                  .cast<RoomModel?>()
                  .firstWhere(
                    (r) => r?.id == widget.roomId,
                    orElse: () => null,
                  );

              int allMembersCount(Map<String, List<StudentsModel>> members) {
                return members.values.fold(0, (sum, list) => sum + list.length);
              }

              int allmembers =
                  room != null ? allMembersCount(room.membersInRoom) : 0;

              // Compute button enable status
              final studentCount = int.tryParse(_to.text.trim()) ?? 0;
              final isSaveEnabled =
                  !_isLoading && selectedExam != null && studentCount > 0;

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
                          ),
                        ],
                      ),
                      child: ListView.separated(
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
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 5),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 🔹 Number of students field
                  TextFormField(
                    controller: _to,
                    decoration: const InputDecoration(
                      hintText: 'No of Students',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Display counts
                  if (selectedExam != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Students: ${selectedExam!.students.length}",
                        ),
                        const SizedBox(height: 4),
                        if (room != null) ...[
                          Text("Room Capacity: ${room.capacity}"),
                          Text("Members in Room: $allmembers"),
                          Text(
                            "Available Seats: ${room.capacity - allmembers}",
                          ),
                          const SizedBox(height: 6),
                          Builder(
                            builder: (_) {
                              final remainingSeats =
                                  room.capacity - allmembers - studentCount;

                              if (studentCount <= 0) {
                                return const Text(
                                  "⚠️ Enter number of new students to add.",
                                  style: TextStyle(color: Colors.orange),
                                );
                              }

                              if (remainingSeats < 0) {
                                return Text(
                                  "❌ Not enough seats! You’re exceeding by ${remainingSeats.abs()} students.",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }

                              return Text(
                                "✅ Seats available. You can add $studentCount students.",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 10),

                  // 🔹 Save button
                  InkWell(
                    onTap: isSaveEnabled
                        ? () async {
                            if (room == null) {
                              Fluttertoast.showToast(
                                msg: "Room not found or not loaded yet",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            if (selectedExam == null) {
                              Fluttertoast.showToast(
                                msg: "Select an exam first",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            try {
                              final result = await roomState.checkRoomAvailability(
                                room: room,
                                count: studentCount,
                                exam: selectedExam!,
                              );

                              if (!result['status']) {
                                Fluttertoast.showToast(
                                  msg: result['message'],
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                                return;
                              }

                              log('✅ Proceed to assign students safely');

                              await roomState.AddExamtoList(
                               
                                 room.id!, selectedExam!.examId!);
                              await roomState.assignStudentsToRoom(
                                exam:  selectedExam!,
                                roomId: room.id!, 
                                count: studentCount,
                              );

                              Fluttertoast.showToast(
                                msg:
                                    "✅ Exam and students assigned successfully!",
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );

                              Navigator.pop(context);
                              Navigator.pop(context);
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "❌ Failed: $e",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        : null,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 45,
                            ),
                            decoration: BoxDecoration(
                              color: isSaveEnabled
                                  ? AppColors.primary
                                  : Colors.grey,
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
      ),
    );
  }
}
