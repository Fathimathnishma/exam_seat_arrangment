// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bca_exam_managment/features/models/student_model.dart';

class RoomModel {
  String? roomName;
  String roomNo;
  int capacity;
  List<String> exams; // ✅ Only exam IDs
  Map<String, List<StudentsModel>> membersInRoom;
  String? layout;
  String? id;
  Timestamp createdAt;

  RoomModel({
    this.roomName,
    required this.roomNo,
    required this.capacity,
    List<String>? exams,
    Map<String, List<StudentsModel>>? membersInRoom,
    this.layout,
    this.id,
    Timestamp? createdAt,
  })  : exams = exams ?? [],
        membersInRoom = membersInRoom ?? {},
        createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'roomNo': roomNo,
      'capacity': capacity,
      'exams': exams, // ✅ just list of IDs
      'membersInRoom': membersInRoom.map(
        (key, value) => MapEntry(key, value.map((s) => s.toMap()).toList()),
      ),
      'layout': layout,
      'id': id,
      'createdAt': createdAt,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    final membersRaw = map['membersInRoom'] as Map<String, dynamic>? ?? {};
    return RoomModel(
      roomName: map['roomName'],
      roomNo: map['roomNo'] ?? '',
      capacity: (map['capacity'] ?? 0).toInt(),
      exams: map['exams'] != null
          ? List<String>.from(map['exams']) // ✅ Fix type mismatch
          : [],
      membersInRoom: membersRaw.map(
        (key, value) => MapEntry(
          key,
          value != null
              ? List<StudentsModel>.from(
                  (value as List).map((x) => StudentsModel.fromMap(x)))
              : [],
        ),
      ),
      layout: map['layout'],
      id: map['id'],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  RoomModel copyWith({
    String? roomName,
    String? roomNo,
    int? capacity,
    List<String>? exams,
    Map<String, List<StudentsModel>>? membersInRoom,
    String? layout,
    String? id,
    Timestamp? createdAt,
  }) {
    return RoomModel(
      roomName: roomName ?? this.roomName,
      roomNo: roomNo ?? this.roomNo,
      capacity: capacity ?? this.capacity,
      exams: exams ?? this.exams,
      membersInRoom: membersInRoom ?? this.membersInRoom,
      layout: layout ?? this.layout,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
