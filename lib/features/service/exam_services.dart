import 'dart:developer';

import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamService {
  final firestore = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance.collection("exams");

  /// Add a new exam with full student list
  Future<void> addExam(ExamModel examModel) async {
    try {
      final id = firebase.doc().id;
      final examRef = firebase.doc(id);

      // attach generated examId
      final exam = examModel.copyWith(examId: id);
        log("3");

      final batch = firestore.batch();
        log("4");

      batch.set(examRef, exam.toMap());
          log("5");

      await batch.commit();
      log("✅ Exam added successfully with ID: $id");
    } catch (e) {
      log("❌ Error while adding exam: $e");
    }
  }

  /// Fetch all exams
  Future<List<ExamModel>> fetchExams() async {
    try {
      final snapshot = await firebase.get();
      return snapshot.docs.map((doc) => ExamModel.fromMap(doc.data())).toList();
    } catch (e) {
      log("❌ Error while fetching exams: $e");
      return [];
    }
  }

  /// Delete an exam by ID
  Future<void> deleteExam(String examId) async {
    try {
      await firebase.doc(examId).delete();
      log("🗑️ Exam deleted successfully with ID: $examId");
    } catch (e) {
      log("❌ Error while deleting exam: $e");
    }
  }

  /// Update an existing exam (e.g., date, courseName, student list)
  Future<void> updateExam(ExamModel examModel) async {
    try {
      await firebase.doc(examModel.examId).update(examModel.toMap());
      log("✏️ Exam updated successfully with ID: ${examModel.examId}");
    } catch (e) {
      log("❌ Error while updating exam: $e");
    }
  }

  /// Fetch rooms where the given examId exists in the `exams` array
   Future<List<RoomModel>> getRoomsByExamId(String examId) async {
    try {
      final querySnapshot = await firestore.collection('Rooms').get();
       log("rron get exist");
     final List<RoomModel> matchedRooms = [];

   for (var doc in querySnapshot.docs) {
  final data = doc.data();

  // Make sure 'exams' exists and is a List
  final rawExams = data['exams'];
  log("Raw exams: $rawExams");

  if (rawExams != null && rawExams is List) {
    // Normalize to a list of Map<String, dynamic> if needed
    final exams = rawExams.map((e) {
      if (e is Map<String, dynamic>) return e;
      // If exams stored as just examId strings
      return {'examId': e};
    }).toList();

    log("Exams after mapping: $exams");

    // Check if any exam matches examId
    final hasExam = exams.any((exam) => exam['examId'] == examId);

    if (hasExam) {
      final room = RoomModel.fromMap(data);
      matchedRooms.add(room);
    }
    log("Matched rooms count: ${matchedRooms.length}");
  } else {
    log("No exams found in this room");
  }
}

    return matchedRooms;
    } catch (e) {
      print('Error fetching rooms by examId: $e');
      return [];
    }
  }
Future<List<ExamModel>> fetchExamsByIds(List<String> examIds) async {
    try {
      if (examIds.isEmpty) return [];

      // Firestore allows up to 10 'in' queries per request, so split if needed
      List<ExamModel> exams = [];

      const batchSize = 10;
      for (var i = 0; i < examIds.length; i += batchSize) {
        final batchIds = examIds.sublist(
            i, (i + batchSize > examIds.length) ? examIds.length : i + batchSize);

        final querySnapshot = await firebase
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();

        exams.addAll(querySnapshot.docs
            .map((doc) => ExamModel.fromMap(doc.data() ))
            .toList());
      }

      return exams;
    } catch (e) {
      log("🔥 Error fetching exams: $e");
      return [];
    }
  }


  // Future<void> deleteExamFromRoom(String roomId, String examId) async {
  //   try {
  //     log("2");
  //     final roomRef = firestore.collection('Rooms').doc(roomId);

  //     await roomRef.update({
  //       'exams': FieldValue.arrayRemove([examId])
  //     });
  //     log("🗑️ Removed examId from exams array");

  //   // 🔹 Remove the exam entry (students) from 'membersInRoom'
  //   await roomRef.update({
  //     'membersInRoom.$examId': FieldValue.delete(),
  //   });
  //   log("✅ Removed members of exam $examId from room $roomId");

  //     log("3");
  //   } catch (e) {
  //     throw Exception('Failed to delete exam from room: $e');
  //   }
  // }
Future<void> deleteExamFromRoom({
  required String roomId,
  required ExamModel exam,
}) async {
  try {
    log("🗑 Starting deleteExamFromRoom...");

    final roomRef = firestore.collection('Rooms').doc(roomId);
    final examRef = firestore.collection('exams').doc(exam.examId);

    // 1️⃣ Load ROOM first
    final roomSnap = await roomRef.get();
    if (!roomSnap.exists) {
      log("❌ Room not found");
      return;
    }

    final roomData = roomSnap.data()!;
    final RoomModel room = RoomModel.fromMap(roomData);

    // 2️⃣ Extract students assigned in THIS room for THIS exam
    final removedStudents = room.membersInRoom[exam.examId] ?? []; // List<StudentsModel>
    log("🧍 Students to restore: ${removedStudents.map((s) => s.regNo).toList()}");

    // 3️⃣ Restore these students back into exam.duplicateStudents
    final updatedDuplicateList = [
      ...exam.duplicatestudents ?? [],
      ...removedStudents
    ];

    // 4️⃣ Mark seats as empty instead of removing them
    final updatedSeats = room.allSeats?.map((seat) {
      if (seat["exam"] == exam.examId) {
        return {
          ...seat,
          "exam": "Empty",                  // mark seat as empty
          "student": null,                  // remove student
          "color": AppColors.grey,       // gray color for empty seat
        };
      }
      return seat;
    }).toList() ?? [];

    // 5️⃣ Remove exam entry from the room model
    final updatedMembers = Map<String, List<StudentsModel>>.from(room.membersInRoom);
    updatedMembers.remove(exam.examId);

    final updatedExams = List<String>.from(room.exams);
    updatedExams.remove(exam.examId);

    // 6️⃣ Create updated ROOM model
    final updatedRoom = room.copyWith(
      exams: updatedExams,
      membersInRoom: updatedMembers,
      allSeats: updatedSeats, // keep all seats but mark as empty
    );

    // 7️⃣ Update Firestore using a batch
    final batch = firestore.batch();
    batch.update(roomRef, updatedRoom.toMap());

    batch.update(
      examRef,
      {
        "duplicatestudents": updatedDuplicateList.map((e) => e.toMap()).toList(),
      },
    );

    await batch.commit();

    log("✅ Exam removed from room & students restored successfully.");

  } catch (e) {
    log("❌ Error deleting exam from room: $e");
    throw Exception("Failed to delete exam from room: $e");
  }
}


}
