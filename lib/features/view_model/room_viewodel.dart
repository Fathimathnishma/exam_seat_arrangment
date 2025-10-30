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
 final allSeats = <Map<String, dynamic>>[];

  bool isLoading = false;
  String? errorMessage;

  // CONTROLLERS
  TextEditingController roomName = TextEditingController();
  TextEditingController roomCode = TextEditingController();
  TextEditingController capacity = TextEditingController();

  // Layout dropdown selection
  String? selectedLayout;

  // To track whether we are updating an existing room
  String? updatingRoomId;

  /// Fetch rooms
  Future<void> fetchRooms() async {
    isLoading = true;
    notifyListeners();

    try {
      allRooms = await _roomRepo.fetchRooms();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Pre-fill controllers for updating
  void setRoomForUpdate(RoomModel room) {
    updatingRoomId = room.id;
    roomName.text = room.roomName ?? '';
    roomCode.text = room.roomNo;
    selectedLayout = room.layout; // ✅ pre-fill dropdown
    capacity.text = room.capacity.toString();
    notifyListeners();
  }

  /// Create RoomModel from controllers
  RoomModel get roomFromControllers => RoomModel(
        id: updatingRoomId,
        roomName: roomName.text.trim(),
        roomNo: roomCode.text.trim(),
        layout: selectedLayout ?? '', // ✅ use dropdown value
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

  //addexamlist
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
    fetchRooms();
    isLoading = false;
    notifyListeners();
  }

  //add students
  Future<void> assignStudentsToRoom({
    required ExamModel exam,
    required String roomId,
    required int count,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final selectedStudents = exam.duplicatestudents.take(count).toList();
      checkAlreadyAssignedStudents(
          selectedStudents: selectedStudents,
          examId: exam.examId!,
          currentRoomId: roomId);
      await _roomRepo.assignStudentsToRoom(
        exam: exam,
        roomId: roomId,
        count: count,
      );
      await arrangeSeatsWithColors();
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
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
 

  void checkAlreadyAssignedStudents({
    required List<StudentsModel> selectedStudents,
    required String examId,
    String? currentRoomId,
  }) {
    for (final student in selectedStudents) {
      final isAssigned = allRooms.any((room) {
        if (room.id == currentRoomId) return false; // skip current room
        final examStudents = room.membersInRoom[examId] ?? [];
        return examStudents.any((s) => s.regNo == student.regNo);
      });

      if (isAssigned) {
        Fluttertoast.showToast(
          msg: "Check again — some of the selected students are already assigned.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return; // stop after first duplicate found
      }
    }
  }


  void clearControllers() {
    roomName.clear();
    roomCode.clear();
    capacity.clear();
    selectedLayout = null; // ✅ reset dropdown
    updatingRoomId = null;
  }

  void clearData() {
    allRooms = [];
    isLoading = false;
    errorMessage = null;
    clearControllers();
    notifyListeners();
  }
//arange seats

List<Map<String, dynamic>> arrangeSeatsWithColors(
  Map<String, List<StudentsModel>> examStudents,
  int totalSeats,
) {
  final random =math. Random();
  final examColors = <String, Color>{};
  final allSeats = <Map<String, dynamic>>[];

  // 🧠 Case 1: Only one exam
  if (examStudents.length == 1) {
    Fluttertoast.showToast(
      msg: "Add more exams to arrange seats properly",
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );

    // Assign color for the single exam
    final examId = examStudents.keys.first;
    examColors[examId] = Colors.blueAccent;

    final students = examStudents[examId] ?? [];

    // Add all students of that exam
    for (final student in students) {
      allSeats.add({
        'student': student,
        'exam': examId,
        'color': examColors[examId],
      });
    }

    // Fill empty seats with grey
    while (allSeats.length < totalSeats) {
      allSeats.add({
        'student': null,
        'exam': null,
        'color': Colors.grey,
      });
    }

    return allSeats;
  }

  // 🧠 Case 2: Multiple exams
  // Assign random color for each exam
  for (var examId in examStudents.keys) {
    examColors[examId] = Color.fromARGB(
      255,
      100 + random.nextInt(155),
      100 + random.nextInt(155),
      100 + random.nextInt(155),
    );
  }

  final examNames = examStudents.keys.toList();
  int index = 0;

  // Alternate students from each exam
  while (examStudents.values.any((s) => s.isNotEmpty)) {
    final exam = examNames[index % examNames.length];
    final list = examStudents[exam]!;

    if (list.isNotEmpty) {
      allSeats.add({
        'student': list.removeAt(0),
        'exam': exam,
        'color': examColors[exam],
      });
    }
    index++;
  }

  // Fill remaining seats with grey
  while (allSeats.length < totalSeats) {
    allSeats.add({
      'student': null,
      'exam': null,
      'color': Colors.grey,
    });
  }

  return allSeats;
}



  /// Returns total number of students in the given exam (0 if null)
  // int totalStudentsForExam(ExamModel? exam) {
  //   return exam?.students.length ?? 0;
  // }

  
}
