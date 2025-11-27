import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
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

Future <List<RoomModel>> getRoomsByExamId(String examId) async {
  return _examService.getRoomsByExamId(examId);   
  }
Future <List<ExamModel>> fetchExamsByIds(List<String> examId) async {
  return _examService.fetchExamsByIds(examId);
  }
  /// Delete room
  Future<bool> deleteExam(ExamModel exam) {
    return _examService.deleteExam(exam);
  }
   Future<void> deleteExamFromRoom(String roomId,ExamModel exam) {
    return _examService.deleteExamFromRoom(  roomId: roomId, exam:exam  );
  }
}
