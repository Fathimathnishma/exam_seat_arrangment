// students_model.dart
import 'dart:convert';
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
      name: _safeString(map['name']),
      regNo: _safeString(map['regNo']),
      department: _safeString(map['department']),
      sem: _safeString(map['sem']),
  
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  static String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  String toJson() => json.encode(toMap());
  factory StudentsModel.fromJson(String source) =>
      StudentsModel.fromMap(json.decode(source));

  @override
  String toString() => 'Student($name - $regNo)';
}
