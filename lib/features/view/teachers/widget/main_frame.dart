// MainFrame
import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  final String examName;
  final String examCode;
  final String time;
  final String sem;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const MainFrame({
    super.key,
    required this.examName,
    required this.examCode,
    required this.time,
    required this.sem,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 4, spreadRadius: 1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.examName,
                    style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w400),
                    maxLines: 2, // Wrap to 2 lines if too long
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color.fromARGB(255, 47, 46, 50)),
                  onSelected: (value) {
                    if (value == 'update') widget.onUpdate?.call();
                    else if (value == 'delete') widget.onDelete?.call();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'update', child: Text('Update')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("Exam Code: ${widget.examCode}", style: TextStyle(fontSize: 13, color: AppColors.textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("Semester: ${widget.sem}", style: TextStyle(fontSize: 13, color: AppColors.textColor)),
            Text("Duration: ${widget.time}", style: TextStyle(fontSize: 13, color: AppColors.textColor)),
          ],
        ),
      ),
    );
  }
}

// RoomFrame
class RoomFrame extends StatefulWidget {
  final String roomName;
  final String roomNo;
  final String capacity;
  final String layout;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const RoomFrame({
    super.key,
    required this.roomName,
    required this.roomNo,
    required this.capacity,
    required this.layout,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<RoomFrame> createState() => _RoomFrameState();
}

class _RoomFrameState extends State<RoomFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 4, spreadRadius: 1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Room name + actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.roomName,
                    style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color.fromARGB(255, 47, 46, 50)),
                  onSelected: (value) {
                    if (value == 'update') widget.onUpdate?.call();
                    else if (value == 'delete') widget.onDelete?.call();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'update', child: Text('Update')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("Room No: ${widget.roomNo}", style: TextStyle(fontSize: 13, color: AppColors.textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("Capacity: ${widget.capacity}", style: TextStyle(fontSize: 13, color: AppColors.textColor)),
            Text("Layout: ${widget.layout}", style: TextStyle(fontSize: 13, color: AppColors.textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
