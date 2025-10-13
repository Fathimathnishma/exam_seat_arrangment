// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bca_exam_managment/features/models/exam_model.dart';

class RoomModel {
  String? roomName;
  String roomNo;
  int capacity;
  List<ExamModel>? exams;
  String? layout;
  String? id;
  Timestamp createdAt;

  RoomModel({
    this.roomName,
    required this.roomNo,
    required this.capacity,
    this.exams,
    this.layout,
    this.id,
    required this.createdAt,
  });

  /// Convert RoomModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomName': roomName,
      'roomNo': roomNo,
      'capacity': capacity,
      'exams': exams != null ? exams!.map((x) => x.toMap()).toList() : [],
      'layout': layout,
      'id': id,
      'createdAt': createdAt,
    };
  }

  /// Create RoomModel from Map (from Firestore)
  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomName: map['roomName'],
      roomNo: map['roomNo'] as String,
      capacity: map['capacity'] as int,
      exams:
          map['exams'] != null
              ? List<ExamModel>.from(
                (map['exams'] as List).map((x) => ExamModel.fromMap(x)),
              )
              : null,
      layout: map['layout'],
      id: map['id'],
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  RoomModel copyWith({
    String? roomName,
    String? roomNo,
    int? capacity,
    List<ExamModel>? exams,
    String? layout,
    String? id,
    Timestamp? createdAt,
  }) {
    return RoomModel(
      roomName: roomName ?? this.roomName,
      roomNo: roomNo ?? this.roomNo,
      capacity: capacity ?? this.capacity,
      exams: exams ?? this.exams,
      layout: layout ?? this.layout,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
