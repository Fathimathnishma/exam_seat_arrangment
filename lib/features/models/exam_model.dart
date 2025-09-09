// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  String? examId;
  String courseName;
  String courseId;
  String duration;
  String department;
  String sem;
  DateTime date;
  List<Students>? students;
  Timestamp creatdAt;
  ExamModel({
    this.examId,
    this.students,
    required this.courseName,
    required this.courseId,
    required this.duration,
    required this.department,
    required this.sem,
    required this.date,
    required this.creatdAt,
  });
}
