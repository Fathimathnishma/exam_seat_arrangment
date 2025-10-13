import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsModel {
  String name;
  String regNo;
  String department;
  String sem;
  Timestamp createdAt;
  StudentsModel({
  
    required this.name,
    required this.regNo,
    required this.department,
    required this.sem,
    required this.createdAt,
  });
  @override
  String toString() {
    return 'Students(name: $name, regNo: $regNo, department: $department, sem: $sem, createdAt: $createdAt)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'regNo': regNo,
      'department': department,
      'sem': sem,
      'createdAt': createdAt,
    };
  }

  factory StudentsModel.fromMap(Map<String, dynamic> map) {
    return StudentsModel(
      name: map['name'] as String,
      regNo: map['regNo'] as String,
      department: map['department'] as String,
      sem: map['sem'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentsModel.fromJson(String source) =>
      StudentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
