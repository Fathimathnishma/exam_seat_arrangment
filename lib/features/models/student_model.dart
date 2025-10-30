import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsModel {
  final String name;
  final String regNo;
  final String department;
  final String sem;
  final String? seatNo;
  final String? roomNo;
  final String? roomName;
  final Timestamp createdAt;

  StudentsModel({
    required this.name,
    required this.regNo,
    required this.department,
    required this.sem,
    this.seatNo,
    this.roomNo,
    this.roomName,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'StudentsModel(name: $name, regNo: $regNo, department: $department, sem: $sem, seatNo: $seatNo, roomNo: $roomNo, roomName: $roomName, createdAt: $createdAt)';
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regNo': regNo,
      'department': department,
      'sem': sem,
      'seatNo': seatNo,
      'roomNo': roomNo,
      'roomName': roomName,
      'createdAt': createdAt,
    };
  }

  /// Create model from Firestore map
  factory StudentsModel.fromMap(Map<String, dynamic> map) {
    return StudentsModel(
      name: map['name'] ?? '',
      regNo: map['regNo'] ?? '',
      department: map['department'] ?? '',
      sem: map['sem'] ?? '',
      seatNo: map['seatNo'],
      roomNo: map['roomNo'],
      roomName: map['roomName'],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Convert to JSON string
  String toJson() => json.encode(toMap());

  /// Create model from JSON string
  factory StudentsModel.fromJson(String source) =>
      StudentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
