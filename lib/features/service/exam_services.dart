import 'dart:developer';

import 'package:bca_exam_managment/features/models/exam_model.dart';
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

      final batch = firestore.batch();
      batch.set(examRef, exam.toMap());

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
}
