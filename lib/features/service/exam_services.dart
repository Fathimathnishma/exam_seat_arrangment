import 'dart:developer';

import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
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

      // Check if 'exams' exists and is a List
      final exams = data['exams'] as List<dynamic>?;
      log("exam exist");

      if (exams != null && exams.isNotEmpty) {
        // Check if any exam in this room has the given examId
        final hasExam = exams.any((exam) {
          if (exam is Map<String, dynamic>) {
            return exam['examId'] == examId;
          }
          return false;
        });
        log("exam exist2");

        if (hasExam) {
          // Convert Firestore data to RoomModel
          final room = RoomModel.fromMap(data);
          matchedRooms.add(room);
        }
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


  Future<void> deleteExamFromRoom(String roomId, String examId) async {
    try {
      log("2");
      final roomRef = firestore.collection('Rooms').doc(roomId);

      await roomRef.update({
        'exams': FieldValue.arrayRemove([examId])
      });
      log("🗑️ Removed examId from exams array");

    // 🔹 Remove the exam entry (students) from 'membersInRoom'
    await roomRef.update({
      'membersInRoom.$examId': FieldValue.delete(),
    });
    log("✅ Removed members of exam $examId from room $roomId");

      log("3");
    } catch (e) {
      throw Exception('Failed to delete exam from room: $e');
    }
  }



}
