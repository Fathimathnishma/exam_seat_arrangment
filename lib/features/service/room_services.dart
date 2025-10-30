import 'dart:developer';

import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomService {
  final firestore = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance.collection("Rooms");
  final examCollection = FirebaseFirestore.instance.collection("exams");

  Future<void> addRoom(RoomModel roomModel) async {
    try {
      final id = firebase.doc().id;
      final roomRef = firebase.doc(id);
      final room = roomModel.copyWith(id: id);

      final batch = firestore.batch();

      batch.set(roomRef, room.toMap());

      await batch.commit();

      log("Room added successfully with ID: $id");
    } catch (e) {
      log("Error while adding room: $e");
    }
  }

  Future<List<RoomModel>> fetchRooms() async {
    try {
      final querySnapshot = await firebase.get();
      final rooms =
          querySnapshot.docs
              .map((doc) => RoomModel.fromMap(doc.data()))
              .toList();

      log("Fetched ${rooms.length} rooms");
      return rooms;
    } catch (e) {
      log("Error while fetching rooms: $e");
      return [];
    }
  }

  Future<void> updateRoom(RoomModel roomModel) async {
    try {
      await firebase.doc(roomModel.id).update(roomModel.toMap());
      log("Room updated successfully: ${roomModel.id}");
    } catch (e) {
      log("Error while updating room: $e");
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await firebase.doc(roomId).delete();
      log("Room deleted successfully: $roomId");
    } catch (e) {
      log("Error while deleting room: $e");
    }
  }
// Assign students to room
Future<void> assignStudentsToRoom({
  required ExamModel exam,
  required String roomId,
  required int count,
}) async {
  log("=== assignStudentsToRoom START ===");
  
  // Step 1: Get duplicate students list
  final dupStudents = exam.duplicatestudents ?? [];
  log("Duplicate students in exam: ${dupStudents.map((s) => s.name).toList()}");
  
  if (dupStudents.isEmpty || count <= 0 || count > dupStudents.length) {
    log("No students to assign or invalid count.");
    return;
  }

  // Step 2: Split selected and remaining
  final selected = dupStudents.take(count).toList();
  final remaining = dupStudents.skip(count).toList();
  log("Selected students to assign: ${selected.map((s) => s.name).toList()}");
  log("Remaining students in exam: ${remaining.map((s) => s.name).toList()}");

  // Step 3: Fetch the room
  final roomSnap = await firebase.doc(roomId).get();
  if (!roomSnap.exists) {
    log("Room not found: $roomId");
    return;
  }
  final room = RoomModel.fromMap(roomSnap.data()!);
  log("Fetched room: ${room.roomNo}, existing members: ${room.membersInRoom}");

  // Step 4: Prepare current members map
  final currentMembers = room.membersInRoom ?? {};
  final existingList = currentMembers[exam.examId] ?? [];
  log("Existing students in this exam in room: ${existingList.map((s) => s.name).toList()}");

  // Step 5: Filter out already assigned students in the same room
  final newStudents = selected.where((s) =>
      !existingList.any((e) => e.regNo == s.regNo)).toList();
  log("Students after removing duplicates in room: ${newStudents.map((s) => s.name).toList()}");

  if (newStudents.isEmpty) {
    log("All selected students are already in this room. Nothing to add.");
    return;
  }

  // Step 6: Add new students
  existingList.addAll(newStudents);
  currentMembers[exam.examId!] = existingList;
  log("Final students list for this exam in room: ${currentMembers[exam.examId]!.map((s) => s.name).toList()}");

  // Step 7: Batch update Firestore
  final batch = firestore.batch();
  final roomRef = firebase.doc(roomId);
  batch.update(roomRef, {
    'membersInRoom': currentMembers.map(
      (key, value) => MapEntry(key, value.map((s) => s.toMap()).toList()),
    ),
  });

  final examRef = examCollection.doc(exam.examId);
  batch.update(examRef, {
    'duplicatestudents': remaining.map((e) => e.toMap()).toList(),
  });

  log("Committing batch updates...");
  await batch.commit();

  log("✅ Students assigned successfully!");
  log("=== assignStudentsToRoom END ===");
}

 Future<void> addExamToRoom(String roomId, String examId) async {
  try {
    final docRef = firebase.doc(roomId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      log("❌ Room not found: $roomId");
      return;
    }

    final room = RoomModel.fromMap(snapshot.data()!);

    // Current exam IDs in the room
    final currentExams = room.exams;

    // Check if exam ID already exists
    if (currentExams.contains(examId)) {
      log("⚠️ Exam already exists in this room: $examId");
      return;
    }

    // Add exam ID
    currentExams.add(examId);

    // Initialize empty student list for this exam
    final currentMembers = room.membersInRoom ?? {};
    currentMembers[examId] = <StudentsModel>[]; // Type-safe empty list

    // Log current members to verify
    currentMembers.forEach((key, value) {
      log("📌 Exam ID: $key, Members count: ${value.length}");
      if (value.isNotEmpty) {
        log("Members: ${value.map((s) => s.name).toList()}");
      } else {
        log("Members list is currently empty for this exam.");
      }
    });

    // Update Firestore
    await docRef.update({
      'exams': currentExams,
      'membersInRoom': currentMembers.map(
        (key, value) => MapEntry(
          key,
          value.map((s) => s.toMap()).toList(),
        ),
      ),
    });

    log("✅ Exam ID added successfully: $examId");
  } catch (e) {
    log("🔥 Error adding exam ID to room: $e");
  }
}



  
}
