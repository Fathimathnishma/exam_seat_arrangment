import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsModel {
  final String name;
  final String regNo;
  final String department;
  final String sem;
  final Timestamp createdAt;

  StudentsModel({
    required this.name,
    required this.regNo,
    required this.department,
    required this.sem,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regNo': regNo,
      'department': department,
      'sem': sem,
      'createdAt': createdAt,
    };
  }

  factory StudentsModel.fromMap(Map<String, dynamic> map) {
    return StudentsModel(
      name: (map['name'] ?? '').toString(),
      regNo: (map['regNo'] ?? '').toString(),
      department: (map['department'] ?? '').toString(),
      sem: (map['sem'] ?? '').toString(),
      createdAt: map['createdAt'] ?? Timestamp,
    );
  }
}
