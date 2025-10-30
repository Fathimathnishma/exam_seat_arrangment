import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/view/teachers/select_students.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel roomModel;
  const RoomDetailScreen({super.key, required this.roomModel});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    const Color.fromRGBO(255, 152, 0, 1),
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
    Colors.grey,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.deepPurple,
  ];
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false).fetchExamsbyId(widget.roomModel.exams);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomName = widget.roomModel.roomName ?? 'N/A';
    final capacity = widget.roomModel.capacity ?? 0;
    final roomNo = widget.roomModel.roomNo ?? 'N/A';
    final matrix = widget.roomModel.layout ?? '2';
    final availability = 'Available';
  

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Center(
          child: Text(
            "Room Details",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectExamDemo(roomId: widget.roomModel.id!),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Consumer<ExamProvider>(
          builder: (BuildContext context, ExamProvider state, Widget? child) {  
              final exams = state.examinRoom;
            return            Column(
            children: [
              // Room Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [Expanded(child: _buildInfoBox("Room Name: $roomName"))],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: _buildInfoBox("Capacity: $capacity")),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoBox("Availability: $availability")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: _buildInfoBox("Room No: $roomNo")),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoBox("Matrix: $matrix")),
                  ],
                ),
              ),
          
              // Check if exams exist
              if (exams.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Exams", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      return MainFrame(
                        examName: exams[index].courseName,
                        examCode: exams[index].courseId,
                        time:exams[index].startTime,
                        sem: exams[index].sem,
                        showDeleteOnlyMenu: true,
                        onDelete: () {
                          state.deleteExamFromRoom(widget.roomModel.id!, exams[index].examId!);
                          Navigator.pop(context);
                        },
                        
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                  ),
                ),
          
                const SizedBox(height: 8),
                Text("Seat Arrangement",
                    style: TextStyle(color: AppColors.textColor, fontSize: 20)),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: exams.length,
                      itemBuilder: (context, index) {
                      final studentsInRoom = widget.roomModel.membersInRoom != null
              ? widget.roomModel.membersInRoom[exams[index].examId ?? ''] ?? []
              : [];
                      return _buildLegendRow(colors[index],exams[index].courseName,studentsInRoom.length.toString());
                    },)
                  ),
                ),
                const SizedBox(height: 8),
          
                // Seat Grid
                if (matrix == '2')
                  _buildSplitGrid(capacity, eachSideCols: 2)
                else if (matrix == '3')
                  _buildSplitGrid(capacity, eachSideCols: 3),
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

  Widget _buildInfoBox(String text) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: AppColors.textColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String exam,String studentsNo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Container(
        height: 50,
        width: double.infinity,
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
            Text("students No:$studentsNo")
          ],
        ),
      ),
    );
  }

  Widget _seatTile(int index, {double? size}) {
    final seatSize = size ?? 45;
    return SizedBox(
      height: seatSize,
      width: seatSize,
      child: Container(
        decoration: BoxDecoration(
          color: colors[index % colors.length],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            "${index + 1}",
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(int totalSeats, {required int crossAxisCount}) {
    double seatSize = 45;
    double spacing = 12;

    if (crossAxisCount == 2) {
      seatSize = 60;
      spacing = 20;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: totalSeats,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => _seatTile(index, size: seatSize),
      ),
    );
  }

  Widget _buildSplitGrid(int totalSeats, {required int eachSideCols}) {
    final int leftCount = totalSeats ~/ 2;
    final int rightCount = totalSeats - leftCount;

    double seatSize = 45;
    double spacing = 12;
    double gridWidth = eachSideCols * seatSize + (eachSideCols - 1) * spacing;
    double gapWidth = eachSideCols == 2 ? 40 : 30;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: gridWidth,
            child: _buildGrid(leftCount, crossAxisCount: eachSideCols),
          ),
          SizedBox(width: gapWidth),
          SizedBox(
            width: gridWidth,
            child: _buildGrid(rightCount, crossAxisCount: eachSideCols),
          ),
        ],
      ),
    );
  }
}
