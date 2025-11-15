
import 'dart:developer';
import 'dart:math' as math;
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/repo/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepo;

  RoomProvider(this._roomRepo);

  List<RoomModel> allRooms = [];
  List<RoomModel> filteredRooms = [];

  bool isLoading = false;
  String? errorMessage;

  // CONTROLLERS
  String? roomName;
  TextEditingController roomCode = TextEditingController();
  TextEditingController capacity = TextEditingController();

  // Layout dropdown selection
  String? selectedLayout;

  // Search and filter
  String? selectedCategory;
  String searchText = "";

  // To track whether we are updating an existing room
  String? updatingRoomId;

  /// Fetch rooms
  Future<void> fetchRooms() async {
    isLoading = true;
    notifyListeners();

    try {
      allRooms = await _roomRepo.fetchRooms();
      filteredRooms = List.from(allRooms);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Search functions
  void onSearchChanged(String? value) {
    searchText = value?.trim().toLowerCase() ?? "";
    filterExams();
  }

  void filterExams() {
    filteredRooms = allRooms.where((event) {
      final matchesName =
          selectedCategory == null || selectedCategory == "All"
              ? true
              : (event.roomName?.toLowerCase() ?? "") ==
                  selectedCategory!.toLowerCase();

      final matchesCode = searchText.isEmpty
          ? true
          : event.roomName!.toLowerCase().contains(searchText) ||
              event.roomNo.toLowerCase().contains(searchText);

      return matchesName && matchesCode;
    }).toList();

    // Reset when filters are empty
    if (filteredRooms.isEmpty &&
        searchText.isEmpty &&
        (selectedCategory == null || selectedCategory == "All")) {
      filteredRooms = List.from(allRooms);
    }

    notifyListeners();
  }

  String getAvailability(int capacity) {
    return capacity > 0 ? 'Available' : 'Not Available';
  }

  /// Pre-fill controllers for updating
  void setRoomForUpdate(RoomModel room) {
    updatingRoomId = room.id;
    roomName = room.roomName ?? '';
    roomCode.text = room.roomNo;
    selectedLayout = room.layout; // pre-fill dropdown
    capacity.text = room.capacity.toString();
    notifyListeners();
  }

  /// Create RoomModel from controllers
  RoomModel get roomFromControllers => RoomModel(
        id: updatingRoomId,
        roomName: roomName!.trim(),
        roomNo: roomCode.text.trim(),
        layout: selectedLayout ?? '',
        capacity: int.tryParse(capacity.text.trim()) ?? 0,
        createdAt: Timestamp.now(), 
        exams: [],
      );

  /// Add or Update room
  Future<void> saveRoom() async {
    if (updatingRoomId == null) {
      await _addRoom();
    } else {
      await _updateRoom();
    }
  }

  Future<void> _addRoom() async {
    try {
      final room = roomFromControllers;
      await _roomRepo.addRoom(room);
      clearControllers();
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _updateRoom() async {
    try {
      final room = roomFromControllers;
      await _roomRepo.updateRoom(room);
      clearControllers();
      updatingRoomId = null;
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Add exam to room
  Future<void> AddExamtoList(String roomId, String examId) async {
    try {
      isLoading = true;
      notifyListeners();
      log(roomId);

      await _roomRepo.addExamToRoom(roomId, examId);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
    await fetchRooms();
    isLoading = false;
    notifyListeners();
  }


Future<Map<String, dynamic>> checkRoomAvailability({
  required RoomModel room,
  required ExamModel exam,
  required int count,
  String? currentRoomId,
}) async {
  final result = <String, dynamic>{};

  // ---------- ROOM SEAT CHECK (FIXED) ----------
  final int totalSeats = room.capacity;

  // If allSeats is null or empty → assigned = 0
  final int assigned = room.allSeats
          ?.where((s) => s["student"] != null)
          .length ??
      0;

  final int availableSeats = totalSeats - assigned;

  result['totalSeats'] = totalSeats;
  result['alreadyAssigned'] = assigned;
  result['availableSeats'] = availableSeats;

  // ---------- CHECK EXAM STUDENTS ----------
  final availableExamStudents = exam.duplicatestudents ?? [];

  if (availableExamStudents.isEmpty) {
    return {
      'status': false,
      'message': '❌ No students available in this exam to assign.'
    };
  }

  if (count <= 0) {
    return {
      'status': false,
      'message': '⚠️ Invalid student count: $count'
    };
  }

  if (count > availableExamStudents.length) {
    return {
      'status': false,
      'message':
          '⚠️ Requested $count students, but only ${availableExamStudents.length} available.'
    };
  }

  // ---------- SELECT UNIQUE STUDENTS ----------
  final selectedStudents = availableExamStudents.take(count).toList();
  final uniqueStudents = {
    for (var s in selectedStudents)
      if (s.regNo != null) s.regNo!: s
  }.values.toList();

  final int newStudentCount = uniqueStudents.length;

  // ---------- CHECK DUPLICATES IN THIS ROOM ----------
  final assignedRegNos = room.allSeats
          ?.where((s) => s["student"] != null)
          .map((s) => (s["student"] as StudentsModel).regNo)
          .whereType<String>()
          .toSet() ??
      {};

  final inThisRoomDuplicates = uniqueStudents
      .where((s) => assignedRegNos.contains(s.regNo))
      .toList();

  // ---------- CHECK OTHER ROOM DUPLICATES ----------
  final alreadyAssignedElsewhere = <StudentsModel>[];

  for (final student in uniqueStudents) {
    final matched = allRooms.any((otherRoom) {
      if (otherRoom.id == currentRoomId) return false;

      final assignedList = otherRoom.membersInRoom[exam.examId] ?? [];
      return assignedList.any((s) => s.regNo == student.regNo);
    });

    if (matched) alreadyAssignedElsewhere.add(student);
  }

  // ---------- DECISION ----------
  if (availableSeats <= 0) {
    return {
      'status': false,
      'message': '❌ Room ${room.roomNo} is FULL ($assigned/$totalSeats).'
    };
  }

  if (newStudentCount > availableSeats) {
    return {
      'status': false,
      'message':
          '⚠️ Only $availableSeats seats left, but trying to assign $newStudentCount students.'
    };
  }

  if (inThisRoomDuplicates.isNotEmpty) {
    return {
      'status': false,
      'message':
          '⚠️ ${inThisRoomDuplicates.length} students already assigned in this same room.'
    };
  }

  // if (alreadyAssignedElsewhere.isNotEmpty) {
  //   return {
  //     'status': false,
  //     'message':
  //         '⚠️ ${alreadyAssignedElsewhere.length} students already assigned in other rooms.'
  //   };
  // }

  // ---------- SUCCESS ----------
  return {
    'status': true,
    'message':
        '✅ Room has $availableSeats seats available. Ready to assign $newStudentCount students.'
  };
}









  void deleteRoom(String roomId) async {
    try {
      await _roomRepo.deleteRoom(roomId);
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

 

  void clearControllers() {
    roomName = "";
    roomCode.clear();
    capacity.clear();
    selectedLayout = null;
    updatingRoomId = null;
  }

  void clearData() {
    allRooms = [];
    isLoading = false;
    errorMessage = null;
    clearControllers();
    notifyListeners();
  }

  // Arrange seats
  String warningMessage = '';
// ------------------ ASSIGN STUDENTS ------------------
Future<void> assignStudentsToRoom({
  required ExamModel exam,
  required String roomId,
  required int count,
}) async {
  try {
    log("=== assignStudentsToRoom START ===");

    // 1. Load room
    final room = await _roomRepo.getRoomById(roomId);
    if (room == null) {
      log("❌ Room not found: $roomId");
      return;
    }

    // 2. Filter students for this exam
    final dupStudents = exam.duplicatestudents ?? [];
    if (dupStudents.isEmpty || count <= 0) {
      log("❌ No students or invalid count");
      return;
    }

    final existingMembers = room.membersInRoom[exam.examId] ?? [];

    // Remove already added students
    final newStudents = dupStudents.where(
      (s) => !existingMembers.any((m) => m.regNo == s.regNo),
    ).toList();

    if (newStudents.isEmpty) {
      log("⚠ All selected students already assigned to this room");
      return;
    }

    final safeCount = count > newStudents.length ? newStudents.length : count;
    final selectedStudents = newStudents.take(safeCount).toList();

    // 3. Update membersInRoom
    room.membersInRoom[exam.examId!] = [...existingMembers, ...selectedStudents];

    // 4. Arrange seats using round-robin for ALL exams
    final updatedSeats = arrangeSeatsWithColors(room)["seats"];

    // 5. Update Firestore
    final updatedRoom = room.copyWith(
      membersInRoom: room.membersInRoom,
      allSeats: updatedSeats,
    );

    await _roomRepo.updateRoom(updatedRoom);

    log("✅ Students assigned and seats updated successfully.");
    log("=== assignStudentsToRoom END ===");
  } catch (e) {
    log("❌ Error in assignStudentsToRoom: $e");
  }
}

Map<String, dynamic> arrangeSeatsWithColors(RoomModel room) {
  final int totalSeats = room.capacity;
  final seats = List<Map<String, dynamic>>.generate(
    totalSeats,
    (i) => {
      "seatNo": "S${i + 1}",
      "student": null,
      "exam": "Empty",
      "color": Color(0xFFCCCCCC).value,
    },
  );

  final examQueues = <String, List<StudentsModel>>{};
  final examColors = <String, int>{};
  final random = math.Random();

  // Prepare queues and colors for all exams
  room.membersInRoom.forEach((examId, students) {
    // Remove duplicates by regNo
    final uniqueStudents = {
      for (var s in students) s.regNo!: s
    }.values.toList();

    examQueues[examId] = uniqueStudents;
    examColors[examId] = Color.fromARGB(
      255,
      random.nextInt(200) + 30,
      random.nextInt(200) + 30,
      random.nextInt(200) + 30,
    ).value;
  });

  int seatIndex = 0;

  // Round-robin placement across exams
  while (examQueues.values.any((q) => q.isNotEmpty) && seatIndex < totalSeats) {
    for (var examId in examQueues.keys) {
      final queue = examQueues[examId]!;
      if (queue.isEmpty) continue;

      // Find next empty seat
      while (seatIndex < totalSeats && seats[seatIndex]['student'] != null) {
        seatIndex++;
      }
      if (seatIndex >= totalSeats) break;

      final student = queue.removeAt(0);
      seats[seatIndex] = {
        "seatNo": "S${seatIndex + 1}",
        "student": student.toMap(),
        "exam": examId,
        "color": examColors[examId],
      };
      seatIndex++;
    }
  }

  return {
    "seats": seats,
    "examColors": examColors,
  };
}

}
