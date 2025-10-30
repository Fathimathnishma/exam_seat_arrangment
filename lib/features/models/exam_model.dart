import 'dart:convert';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  String? examId;
  int totalStudents;
  String courseName;
  String courseId;
  String duration;
  String startTime;
  String endTime;
  String department;
  String sem;
  String date;
  List<StudentsModel> students;
  List<StudentsModel> duplicatestudents;
  Timestamp createdAt;

  ExamModel({
    this.examId,
    int? totalStudents,
    required this.courseName,
    required this.courseId,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.department,
    required this.sem,
    required this.date,
    List<StudentsModel>? students,
    List<StudentsModel>? duplicatestudents,
    Timestamp? createdAt,
  })  : totalStudents = totalStudents ?? 0,
        students = students ?? [],
        duplicatestudents = duplicatestudents ?? [],
        createdAt = createdAt ?? Timestamp.now();

  ExamModel copyWith({
    String? examId,
    int? totalStudents,
    String? courseName,
    String? courseId,
    String? duration,
    String? startTime,
    String? endTime,
    String? department,
    String? sem,
    String? date,
    List<StudentsModel>? students,
    List<StudentsModel>? duplicatestudents,
    Timestamp? createdAt,
  }) {
    return ExamModel(
      examId: examId ?? this.examId,
      totalStudents: totalStudents ?? this.totalStudents,
      courseName: courseName ?? this.courseName,
      courseId: courseId ?? this.courseId,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      department: department ?? this.department,
      sem: sem ?? this.sem,
      date: date ?? this.date,
      students: students ?? this.students,
      duplicatestudents: duplicatestudents ?? this.duplicatestudents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'totalStudents': totalStudents,
      'courseName': courseName,
      'courseId': courseId,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
      'department': department,
      'sem': sem,
      'date': date,
      'students': students.map((x) => x.toMap()).toList(),
      'duplicatestudents': duplicatestudents.map((x) => x.toMap()).toList(),
      'createdAt': createdAt,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      examId: map['examId'],
      totalStudents: map['totalStudents'] is int
          ? map['totalStudents']
          : int.tryParse(map['totalStudents']?.toString() ?? '0') ?? 0,
      courseName: map['courseName'] ?? '',
      courseId: map['courseId'] ?? '',
      duration: map['duration'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      department: map['department'] ?? '',
      sem: map['sem'] ?? '',
      date: map['date'] ?? '',
      students: map['students'] != null
          ? List<StudentsModel>.from(
              (map['students'] as List).map(
                (x) => StudentsModel.fromMap(x),
              ),
            )
          : [],
      duplicatestudents: map['duplicatestudents'] != null
          ? List<StudentsModel>.from(
              (map['duplicatestudents'] as List).map(
                (x) => StudentsModel.fromMap(x),
              ),
            )
          : [],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExamModel.fromJson(String source) =>
      ExamModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
