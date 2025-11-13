import 'dart:developer';
import 'dart:math' as math;
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/repo/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final int totalSeats = room.capacity;
  final int assigned = room.allSeats.length;
  final int availableSeats = totalSeats - assigned;

  final result = <String, dynamic>{
    'totalSeats': totalSeats,
    'alreadyAssigned': assigned,
    'availableSeats': availableSeats,
  };

  // 🔹 Safe exam student list
  final availableExamStudents = exam.duplicatestudents ?? [];
  if (availableExamStudents.isEmpty) {
    result['status'] = false;
    result['message'] = '❌ No students available in this exam to assign.';
    return result;
  }

  // 🔹 Validate count vs available
  if (count <= 0) {
    result['status'] = false;
    result['message'] = '⚠️ Invalid student count: $count';
    return result;
  }

  if (count > availableExamStudents.length) {
    result['status'] = false;
    result['message'] =
        '⚠️ Requested $count students, but only ${availableExamStudents.length} available.';
    return result;
  }

  // 🔹 Select and deduplicate students
  final selectedStudents = availableExamStudents.take(count).toList();
  final uniqueStudents = {
    for (var s in selectedStudents.where((s) => s.regNo != null)) s.regNo!: s
  }.values.toList();
  final newStudentCount = uniqueStudents.length;

  // 🔹 Already assigned in this room
  final assignedRegNos = room.allSeats
      .map((s) => (s['student'] as StudentsModel?)?.regNo)
      .whereType<String>()
      .toSet();

  final inThisRoomDuplicates =
      uniqueStudents.where((s) => assignedRegNos.contains(s.regNo)).toList();

  // 🔹 Already assigned in other rooms
  final alreadyAssignedElsewhere = <StudentsModel>[];
  for (final student in uniqueStudents) {
    final isAssignedElsewhere = allRooms.any((otherRoom) {
      if (otherRoom.id == currentRoomId) return false;
      final assignedList = otherRoom.membersInRoom[exam.examId] ?? [];
      return assignedList.any((s) => s.regNo == student.regNo);
    });
    if (isAssignedElsewhere) alreadyAssignedElsewhere.add(student);
  }

  result['examStudentCount'] = newStudentCount;
  result['inThisRoomDuplicates'] =
      inThisRoomDuplicates.map((e) => e.name).toList();
  result['alreadyAssignedElsewhere'] =
      alreadyAssignedElsewhere.map((e) => e.name).toList();

  // 🔹 Determine final status
  if (availableSeats <= 0) {
    result['status'] = false;
    result['message'] =
        '❌ Room ${room.roomNo} is full ($assigned/$totalSeats).';
  } else if (newStudentCount > availableSeats) {
    result['status'] = false;
    result['message'] =
        '⚠️ Only $availableSeats seats left, but trying to assign $newStudentCount students.';
  } else if (inThisRoomDuplicates.isNotEmpty) {
    result['status'] = false;
    result['message'] =
        '⚠️ ${inThisRoomDuplicates.length} students already assigned in this room.';
  } else if (alreadyAssignedElsewhere.isNotEmpty) {
    result['status'] = false;
    result['message'] =
        '⚠️ ${alreadyAssignedElsewhere.length} students already assigned in other rooms.';
  } else {
    result['status'] = true;
    result['message'] =
        '✅ Room has $availableSeats seats available. Ready to assign $newStudentCount students.';
  }

  return result;
}



  // Add students
Future<void> assignStudentsToRoom({
  required ExamModel exam,
  required String roomId,
  required int count,
}) async {
  isLoading = true;
  notifyListeners();

  try {
    log("🟢 Starting assignment for Room ID: $roomId");

    // 1️⃣ Assign selected students to Firebase (updates membersInRoom)
    await _roomRepo.assignStudentsToRoom(
      exam: exam,
      roomId: roomId,
      count: count,
    );

    // 2️⃣ Fetch the latest room data
    RoomModel updatedRoom = await _roomRepo.getRoomById(roomId);
    log("✅ Room fetched: ${updatedRoom.roomNo}, capacity: ${updatedRoom.capacity}");

    // 3️⃣ Arrange seats (ensure safe data structure)
    final arrangement = arrangeSeatsWithColors(
      Map<String, List<StudentsModel>>.from(updatedRoom.membersInRoom),
      updatedRoom.capacity,
      room: updatedRoom,
    );

    // 4️⃣ Log the arrangement locally
    log("🪑 Local seat arrangement:");
    for (var seat in arrangement['seats']) {
      log("   Seat -> Exam: ${seat['exam']}, "
          "Student: ${seat['student']?['name'] ?? 'null'}, "
          "Color: ${seat['color']}");
    }

    // 5️⃣ Convert Color to int and StudentModel to map
    final safeSeats = (arrangement['seats'] as List)
        .map((seat) => {
              'exam': seat['exam'] ?? 'Empty',
              'color': (seat['color'] is Color)
                  ? (seat['color'] as Color).value
                  : seat['color'] ?? 0xFFBDBDBD, // grey fallback
              'student': (seat['student'] is StudentsModel)
                  ? (seat['student'] as StudentsModel).toMap()
                  : seat['student'], // may already be null or map
            })
        .toList();

    updatedRoom = updatedRoom.copyWith(allSeats: safeSeats);

    // 6️⃣ Log after conversion
    log("📦 Prepared ${safeSeats.length} safe seat maps to update Firestore");

    // 7️⃣ Push updated data safely
    await _roomRepo.updateRoom(updatedRoom);
    log("✅ Room update success: ${updatedRoom.id}");

    // 8️⃣ Refresh rooms
    await fetchRooms();
  } catch (e, st) {
    log("❌ ERROR during assignStudentsToRoom: $e");
    log("🪲 StackTrace: $st");
    errorMessage = e.toString();
    Fluttertoast.showToast(msg: "❌ $errorMessage");
  }

  isLoading = false;
  notifyListeners();
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
Map<String, dynamic> arrangeSeatsWithColors(
  Map<String, List<StudentsModel>> examStudents,
  int totalSeats, {
  RoomModel? room,
}) {
  final random = math.Random();
  final examColors = <String, Color>{};
  final allSeats = <Map<String, dynamic>>[];
  String warningMessage = '';

  if (examStudents.isEmpty) {
    return {'seats': [], 'message': "❌ No students found"};
  }
  if (totalSeats <= 0) {
    return {'seats': [], 'message': "❌ Invalid room capacity"};
  }

  // Assign color per exam
  for (var examId in examStudents.keys) {
    examColors[examId] = Color.fromARGB(
      255,
      80 + random.nextInt(150),
      80 + random.nextInt(150),
      80 + random.nextInt(150),
    );
  }

  // Distribute fairly by alternating
  final examQueue = examStudents.keys.toList();
  while (examStudents.values.any((v) => v.isNotEmpty)) {
    examQueue.sort((a, b) => examStudents[b]!.length.compareTo(examStudents[a]!.length));
    String? current;
    for (var e in examQueue) {
      if (allSeats.isEmpty || allSeats.last['exam'] != e) {
        current = e;
        break;
      }
    }
    current ??= examQueue.first;
    final list = examStudents[current]!;
    if (list.isNotEmpty) {
      allSeats.add({
        'student': list.removeAt(0),
        'exam': current,
        'color': examColors[current],
      });
    }
  }

  // Fill empty seats
  while (allSeats.length < totalSeats) {
    allSeats.add({'student': null, 'exam': 'Empty', 'color': Colors.grey});
  }

  if (room != null) room.allSeats = allSeats;
  return {'seats': allSeats, 'message': warningMessage};
}

}
