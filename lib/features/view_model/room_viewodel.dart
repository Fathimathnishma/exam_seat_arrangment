
import 'dart:developer';
import 'dart:math' as math;
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/repo/exam_repo.dart';
import 'package:bca_exam_managment/features/repo/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepo;
  final ExamRepository _examRepo;

  RoomProvider(this._roomRepo, this._examRepo);

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
String? selectedBlock = "All";


  // To track whether we are updating an existing room
  String? updatingRoomId;

//filter by block

List<String> get blockList {
  final blocks = allRooms.map((e) => e.roomName!).toSet().toList();
  blocks.sort();
  return ["All", ...blocks];
}




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

    // roomName IS block name
    final matchesBlock = selectedBlock == "All"
        ? true
        : event.roomName!.toLowerCase() == selectedBlock!.toLowerCase();

    final matchesSearch = searchText.isEmpty
        ? true
        : event.roomName!.toLowerCase().contains(searchText) ||
            event.roomNo.toLowerCase().contains(searchText);

    return matchesBlock && matchesSearch;
  }).toList();

  notifyListeners();
}

String getAvailability(RoomModel room) {
  final int totalSeats = room.capacity;

  final List seats = room.allSeats ?? [];

  // Count assigned seats
  final int assigned = seats
      .where((s) =>
          s["student"] != null &&
          ((s["student"] is StudentsModel &&
                  (s["student"] as StudentsModel).regNo.isNotEmpty) ||
              (s["student"] is Map &&
                  (s["student"]["regNo"] ?? "").toString().isNotEmpty)))
      .length;

  final int availableSeats = totalSeats - assigned;

  // Only check if ANY seat is available
  return availableSeats > 0 ? "Available" : "Not Available";
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









 Future<bool> deleteRoom(String roomId) async {
  final result = await _roomRepo.deleteRoom(roomId);

  if (result) {
    await fetchRooms();
    return true;
  } else {
    return false; // upcoming exam exists OR error
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
   isLoading = true;
  notifyListeners(); // Start loading

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
    log("Duplicate students: ${dupStudents.map((s) => s.regNo).toList()}");

    if (dupStudents.isEmpty || count <= 0) {
      log("❌ No students or invalid count");
      return;
    }

    // Existing members for this exam
    final existingMembers = room.membersInRoom[exam.examId] ?? [];

    // Remove already assigned students
    final newStudents = dupStudents.where(
      (s) => !existingMembers.any((m) => m.regNo == s.regNo),
    ).toList();

    if (newStudents.isEmpty) {
      log("⚠ All selected students already assigned to this room");
      return;
    }

    // Apply safe count
    final safeCount = count > newStudents.length ? newStudents.length : count;
    final selectedStudents = newStudents.take(safeCount).toList();
    final remainingStudents = newStudents.skip(safeCount).toList();

    log("Selected students for assignment: ${selectedStudents.map((s) => s.regNo).toList()}");
    log("Remaining duplicates after assignment: ${remainingStudents.map((s) => s.regNo).toList()}");

    // 3. Update membersInRoom with deduplication
    room.membersInRoom[exam.examId!] = [
      ...existingMembers,
      ...selectedStudents,
    ]
        .fold<Map<String, StudentsModel>>({}, (map, student) {
      map[student.regNo!] = student; // key by regNo to remove duplicates
      return map;
    })
        .values
        .toList();

    log("Final members in room for exam ${exam.examId}: ${room.membersInRoom[exam.examId]!.map((s) => s.regNo).toList()}");

    // 4. Arrange seats for ALL exams using round-robin
    final updatedSeats = arrangeSeatsWithColors(room)["seats"];

    // 5. Update Firestore
    final updatedRoom = room.copyWith(
      membersInRoom: room.membersInRoom,
      allSeats: updatedSeats,
    );

    await _roomRepo.updateRoom(updatedRoom);

    // 6. Update remaining duplicates in Exam
    await _examRepo.updateExam(
      exam.copyWith(
        duplicatestudents: remainingStudents,
      ),
    );
    fetchRooms();

    log("✅ Students assigned and seats updated successfully.");
    log("=== assignStudentsToRoom END ===");
  } catch (e) {
    log("❌ Error in assignStudentsToRoom: $e");
  }finally{
    isLoading = false;
    notifyListeners(); // End loading, refresh UI
  }
}
Map<String, dynamic> arrangeSeatsWithColors(RoomModel room) {
  final int total = room.capacity;

  // STEP 1: Create empty seats
  final seats = List.generate(total, (i) => {
        "seatNo": "S${i + 1}",
        "student": null,
        "exam": "Empty",
        "color": const Color(0xFFCCCCCC).value,
      });

  final random = math.Random();
  final examColors = <String, int>{};

  // STEP 2: Collect unique students for each exam
  final examStudents = <String, List<StudentsModel>>{};
  room.membersInRoom.forEach((examId, list) {
    final unique = {
      for (var s in list) s.regNo!: s,
    }.values.toList();

    if (unique.isNotEmpty) {
      examStudents[examId] = unique;

      examColors[examId] = Color.fromARGB(
        255,
        random.nextInt(200) + 30,
        random.nextInt(200) + 30,
        random.nextInt(200) + 30,
      ).value;
    }
  });

  // STEP 3: Sort exams by largest student count
  final sortedExams = examStudents.keys.toList()
    ..sort((a, b) => examStudents[b]!.length.compareTo(examStudents[a]!.length));

  int filled = 0; // How many seats filled so far

  for (final examId in sortedExams) {
    final students = examStudents[examId]!;

    for (final student in students) {
      if (filled >= total) break;

      // Calculate zig-zag index
      int index;
      if (filled < (total / 2).ceil()) {
        // First half → even indexes: 0,2,4...
        index = filled * 2;
      } else {
        // Second half → odd indexes: 1,3,5...
        index = (filled - (total / 2).ceil()) * 2 + 1;
      }

      if (index >= total) {
        // If odd index overflows, place in next free seat
        index = seats.indexWhere((e) => e["student"] == null);
        if (index == -1) break;
      }

      // Fill seat
      seats[index] = {
        "seatNo": "S${index + 1}",
        "student": student.toMap(),
        "exam": examId,
        "color": examColors[examId],
      };

      filled++;
    }
  }

  return {
    "seats": seats,
    "examColors": examColors,
  };
}


}