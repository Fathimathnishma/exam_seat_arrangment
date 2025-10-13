import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/service/exam_services.dart';
import 'package:flutter/material.dart';

class ExamRepository {
  final ExamService _examService;

  ExamRepository(this._examService);

  /// Add room
  Future<void> addExam(ExamModel exam) {
    return _examService.addExam(exam);
  }

  /// Fetch all rooms once
  Future<List<ExamModel>> fetchExam() {
    return _examService.fetchExams();
  }

  /// Update room
  Future<void> updateExam(ExamModel exam) {
    return _examService.updateExam(exam);
  }

  /// Delete room
  Future<void> deleteExam(String examId) {
    return _examService.deleteExam(examId);
  }
}
