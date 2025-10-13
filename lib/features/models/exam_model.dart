// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';

class ExamModel {
  String? examId;
  String courseName;
  String courseId;
  String duration;
  String startTime;
  String endTime;
  String department;
  String sem;
  String date;
  List<StudentsModel>? students;
  Timestamp createdAt;

  ExamModel({
    this.examId,
    this.students,
    required this.courseName,
    required this.courseId,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.department,
    required this.sem,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'courseName': courseName,
      'courseId': courseId,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
      'department': department,
      'sem': sem,
      'date': date,
      'students': students != null
          ? students!.map((x) => x.toMap()).toList()
          : [],
      'createdAt': createdAt,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      examId: map['examId']?.toString(),
      courseName: map['courseName']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      department: map['department']?.toString() ?? '',
      sem: map['sem']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      students: map['students'] != null
          ? List<StudentsModel>.from(
              (map['students'] as List)
                  .map((x) => StudentsModel.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }

  String? get id => examId;

  ExamModel copyWith({
    String? examId,
    String? courseName,
    String? courseId,
    String? duration,
    String? startTime,
    String? endTime,
    String? department,
    String? sem,
    String? date,
    List<StudentsModel>? students,
    Timestamp? createdAt,
  }) {
    return ExamModel(
      examId: examId ?? this.examId,
      courseName: courseName ?? this.courseName,
      courseId: courseId ?? this.courseId,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      department: department ?? this.department,
      sem: sem ?? this.sem,
      date: date ?? this.date,
      students: students ?? this.students,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
