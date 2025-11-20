import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/pdf_preview.dart';
import 'package:bca_exam_managment/features/view/teachers/select_students.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/room_viewodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel roomModel; // ✔ required
  const RoomDetailScreen({super.key, required this.roomModel});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  RoomModel? updatedRoom; // ✔ this holds the refreshed room

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final examProvider = Provider.of<ExamProvider>(context, listen: false);
      await examProvider.fetchExamsbyId(widget.roomModel.exams);

      final roomProvider = Provider.of<RoomProvider>(context, listen: false);

      setState(() {
        updatedRoom = roomProvider.allRooms.firstWhere(
          (r) => r.id == widget.roomModel.id,
          orElse: () => widget.roomModel,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = updatedRoom ?? widget.roomModel;

    final roomName = room.roomName ?? "N/A";
    final capacity = room.capacity;
    final roomNo = room.roomNo;
    final matrix = room.layout ?? "2";


    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Room Details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
      ),
   floatingActionButton: Consumer<RoomProvider>(
  builder: (context, roomProvider, _) {
    final assigned = room.allSeats.where(
      (s) => s["student"] != null && s["student"] != "Empty",
    ).length;

    final isFull = assigned >= room.capacity;

    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        if (isFull) {
          // 👉 DOWNLOAD PDF
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomPdfScreen(room: room),
            ),
          );
        } else {
          // 👉 ADD STUDENTS
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectExamDemo(roomId: room.id!),
            ),
          );
        }
      },
      child: Icon(
        isFull ? Icons.download : Icons.add,
        color: Colors.white,
      ),
    );
  },
),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<ExamProvider, RoomProvider>(
          builder: (context, examState, roomState, _) {
            if (examState.isLoading || roomState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
            final exams = examState.examinRoom;
            final availability = roomState.getAvailability(room);
             if (examState.isLoading) {
          // Simple loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowInfo("Room Name", roomName),
                _buildRowInfo("Capacity", capacity.toString(), "Status", availability),
                _buildRowInfo("Room No", roomNo, "Layout", matrix),
                const SizedBox(height: 20),

                // ---------------- Exams ----------------
                if (exams.isNotEmpty) ...[
                  const Text(
                    "Exams",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      final exam = exams[index];
                      return MainFrame(
                        examName: exam.courseName,
                        examCode: exam.courseId,
                        time: exam.startTime,
                        sem: exam.sem,
                        showDeleteOnlyMenu: true,
                        onDelete: () {
                          examState.deleteExamFromRoom(() {
                            roomState.fetchRooms();
                          },room.id!, exam.examId!);
                          Navigator.pop(context);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Seat Arrangement",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  if (roomState.warningMessage.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orangeAccent),
                      ),
                      child: Text(
                        roomState.warningMessage,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  _buildSeatArrangement(room.allSeats, matrix, exams),
                ] else ...[
                  const SizedBox(height: 20),
                  const Text(
                    "No exams assigned yet.",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label1, String value1, [String? label2, String? value2]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _buildInfoBox("$label1: $value1")),
          if (label2 != null && value2 != null) ...[
            const SizedBox(width: 7),
            Expanded(child: _buildInfoBox("$label2: $value2")),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: AppColors.textColor, fontSize: 13),
      ),
    );
  }

  // ---------------- Seat Arrangement ----------------
 // ---------------- Seat Arrangement ----------------
Widget _buildSeatArrangement(
    List<Map<String, dynamic>> allSeats,
    String matrix,
    List<ExamModel> exams) {
  if (allSeats.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        "No seats assigned.",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  final Map<String, Map<String, dynamic>> examSummary = {};

  for (var seat in allSeats) {
    final examId = seat['exam'];
    final colorValue = seat['color'];
    final color = colorValue is int ? Color(colorValue) : Colors.grey;

    if (examId == null || examId == "Empty") continue;

    final examExists = exams.any((e) => e.examId == examId);
    final validExamId = examExists ? examId : 'Unknown Exam';

    examSummary.putIfAbsent(validExamId, () => {'color': color, 'count': 0});
    examSummary[validExamId]!['count']++;
  }

  int eachSideCols = matrix == '3' ? 3 : 2;

  // Split seats into left & right
  final int leftCount = allSeats.length ~/ 2;
  final leftSeats = allSeats.sublist(0, leftCount);
  final rightSeats = allSeats.sublist(leftCount);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      const Text(
        "Exam Color Legend",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),

      // ---------------- Legend ----------------
      if (examSummary.isEmpty)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No exams arranged yet.", style: TextStyle(color: Colors.grey)),
        )
      else
        ...examSummary.entries.map((entry) {
          final examName = entry.key;
          final color = entry.value['color'] as Color;
          final count = entry.value['count'].toString();

          if (examName == 'Unknown Exam') {
            return _buildLegendRow(Colors.yellow.shade700, "Unknown Exam", count);
          }

          final exam = exams.firstWhere(
            (e) => e.examId == examName,
            orElse: () => ExamModel(
              examId: '',
              courseName: '',
              courseId: '',
              startTime: '',
              sem: '',
              students: [],
              duplicatestudents: [],
              duration: '',
              endTime: '',
              department: '',
              date: '',
            ),
          );

          return _buildLegendRow(color, exam.courseName, count);
        }),

      const SizedBox(height: 20),

      // ---------------- LEFT & RIGHT GRID ----------------
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildGrid(
              leftSeats,
              crossAxisCount: eachSideCols,
              startSeatNo: 1,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: _buildGrid(
              rightSeats,
              crossAxisCount: eachSideCols,
              startSeatNo: leftSeats.length + 1, // Continuous numbering
            ),
          ),
        ],
      ),
    ],
  );
}

// ---------------- GRID with continuous seat numbering ----------------
Widget _buildGrid(
  List<Map<String, dynamic>> seats, {
  required int crossAxisCount,
  required int startSeatNo,
}) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: seats.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final seat = seats[index];
      final student = seat['student'];

      final colorValue = seat['color'];
      final color = colorValue is int
          ? Color(colorValue)
          : (colorValue is Color ? colorValue : Colors.grey);

      final seatNo = 'S${startSeatNo + index}'; // ✔ continuous numbering

      String regNo = '';
      if (student is StudentsModel) {
        regNo = student.regNo;
      } else if (student is Map<String, dynamic>) {
        regNo = student['regNo'] ?? '';
      }

      return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                regNo.isNotEmpty ? regNo : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  seatNo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  
  Widget _buildLegendRow(Color color, String exam, String studentsNo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color, radius: 9),
              const SizedBox(width: 10),
              Text(exam, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text("Students: $studentsNo"),
        ],
      ),
    );
  }
}
