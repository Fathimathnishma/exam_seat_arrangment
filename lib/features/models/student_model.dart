import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  String? id;
  String name;
  String regNo;
  String department;
  String sem;
  Timestamp createdAt;
  Students({
    this.id,
    required this.name,
    required this.regNo,
    required this.department,
    required this.sem,
    required this.createdAt,
  });
  @override
  String toString() {
    return 'Students(id: $id, name: $name, regNo: $regNo, department: $department, sem: $sem, createdAt: $createdAt)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'regNo': regNo,
      'department': department,
      'sem': sem,
      'createdAt': createdAt,
    };
  }

  factory Students.fromMap(Map<String, dynamic> map) {
    return Students(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      regNo: map['regNo'] as String,
      department: map['department'] as String,
      sem: map['sem'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Students.fromJson(String source) =>
      Students.fromMap(json.decode(source) as Map<String, dynamic>);
}
