// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

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
  List<Map<String, dynamic>> allSeats; // ✅ NEW FIELD

  RoomModel({
    this.roomName,
    required this.roomNo,
    required this.capacity,
    List<String>? exams,
    Map<String, List<StudentsModel>>? membersInRoom,
    this.layout,
    this.id,
    Timestamp? createdAt,
    List<Map<String, dynamic>>? allSeats,
  })  : exams = exams ?? [],
        membersInRoom = membersInRoom ?? {},
        allSeats = allSeats ?? [],
        createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'roomNo': roomNo,
      'capacity': capacity,
      'exams': exams,
      'membersInRoom': membersInRoom.map(
        (key, value) => MapEntry(
          key,
          value.map((s) => s.toMap()).toList(),
        ),
      ),
      'layout': layout,
      'id': id,
      'createdAt': createdAt,
      // ✅ Fix: ensure StudentsModel objects inside allSeats are converted to Map
      'allSeats': allSeats.map((seat) {
  return {
    'exam': seat['exam'] ?? 'Empty',
    'color': seat['color'] is int
        ? seat['color']
        : (seat['color'] is Color ? (seat['color'] as Color).value : 0xFFBDBDBD),
    'student': seat['student'] is StudentsModel
        ? (seat['student'] as StudentsModel).toMap()
        : seat['student'],
  };
}).toList(),

    };
  }

 factory RoomModel.fromMap(Map<String, dynamic> map) {
  final membersRaw = map['membersInRoom'] as Map<String, dynamic>? ?? {};

  return RoomModel(
    roomName: map['roomName'],
    roomNo: map['roomNo'] ?? '',
    capacity: (map['capacity'] ?? 0).toInt(),
    exams: map['exams'] != null ? List<String>.from(map['exams']) : [],
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

    // ✅ FIXED: Safely convert each seat and rebuild student as StudentsModel
    allSeats: (map['allSeats'] as List?)
            ?.map((seat) {
              final seatMap = Map<String, dynamic>.from(seat);
              return {
                'exam': seatMap['exam'] ?? 'Empty',
                'color': seatMap['color'],
                'student': seatMap['student'] != null
                    ? StudentsModel.fromMap(
                        Map<String, dynamic>.from(seatMap['student']),
                      )
                    : null,
              };
            })
            .toList() ??
        [],
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
    List<Map<String, dynamic>>? allSeats,
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
      allSeats: allSeats ?? this.allSeats, // ✅ included in copyWith
    );
  }
}
