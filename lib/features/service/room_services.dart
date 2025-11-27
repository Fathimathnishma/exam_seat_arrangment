import 'dart:developer';
import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomService {
  final firestore = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance.collection("Rooms");
  final examCollection = FirebaseFirestore.instance.collection("exams");

  // ---------------------------------------------------------------------------
  // ADD ROOM
  // ---------------------------------------------------------------------------
  Future<void> addRoom(RoomModel roomModel) async {
    try { 
      final id = firebase.doc().id;
      final roomRef = firebase.doc(id);
      final room = roomModel.copyWith(id: id);

      await roomRef.set(room.toMap());

      log("Room added successfully with ID: $id");
    } catch (e) {
      log("Error while adding room: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH ROOMS
  // ---------------------------------------------------------------------------
  Future<List<RoomModel>> fetchRooms() async {
    try {
      final querySnapshot = await firebase.get();

      final rooms = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RoomModel.fromMap(data);
      }).toList();

      log("Fetched ${rooms.length} rooms");
      return rooms;
    } catch (e) {
      log("Error while fetching rooms: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE ROOM
  // ---------------------------------------------------------------------------
  Future<void> updateRoom(RoomModel roomModel) async {
    try {
      log("Updating room…");
      await firebase.doc(roomModel.id).update(roomModel.toMap());
      log("Room updated successfully: ${roomModel.id}");
    } catch (e) {
      log("Error while updating room: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // GET ROOM BY ID
  // ---------------------------------------------------------------------------
  Future<RoomModel> getRoomById(String roomId) async {
    try {
      final doc = await firebase.doc(roomId).get();

      if (!doc.exists) throw Exception("Room not found for ID: $roomId");

      final data = doc.data()!;
      data['id'] = doc.id;

      final roomModel = RoomModel.fromMap(data);

      log("Room fetched successfully: ${roomModel.id}");
      return roomModel;
    } catch (e) {
      log("Error while fetching room: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE ROOM
  // ---------------------------------------------------------------------------
 Future<bool> deleteRoom(String roomId) async {
  try {
    final roomDoc = await firebase.doc(roomId).get();

    if (!roomDoc.exists) {
      log("⚠️ Room not found: $roomId");
      return false;
    }

    final data = roomDoc.data() as Map<String, dynamic>;
    final exams = List<String>.from(data['exams'] ?? []);

    // ------------------------------------------------------
    // 🔍 CHECK FOR UPCOMING EXAMS
    // ------------------------------------------------------
    for (String examId in exams) {
      final examSnap = await FirebaseFirestore.instance
          .collection("exams")
          .doc(examId)
          .get();

      if (!examSnap.exists) continue;

      final examData = examSnap.data()!;
      final examDate = (examData['date'] as Timestamp).toDate();
      final examTime = examData['startTime']; // "09:30 AM"

      // Parse startTime
      final parts = examTime.split(" ");
      final hm = parts[0].split(":");
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final ampm = parts[1];

      if (ampm == "PM" && hour != 12) hour += 12;
      if (ampm == "AM" && hour == 12) hour = 0;

      final examDateTime = DateTime(
        examDate.year,
        examDate.month,
        examDate.day,
        hour,
        minute,
      );

      // ⛔ BLOCK DELETE IF FUTURE EXAM DETECTED
      if (examDateTime.isAfter(DateTime.now())) {
        log("❌ Cannot delete. Upcoming exam found: $examId");
        return false;
      }
    }

    // ------------------------------------------------------
    // ✅ SAFE TO DELETE
    // ------------------------------------------------------
    await firebase.doc(roomId).delete();
    log("🗑️ Room deleted successfully: $roomId");
    return true;

  } catch (e) {
    log("🔥 Error deleting room: $e");
    return false;
  }
}




  // ---------------------------------------------------------------------------
  // ADD EXAM TO ROOM
  // ---------------------------------------------------------------------------
  Future<void> addExamToRoom(String roomId, String examId) async {
    try {
      final docRef = firebase.doc(roomId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        log("Room not found: $roomId");
        return;
      }

      final data = snapshot.data()!;
      data['id'] = snapshot.id;
      final room = RoomModel.fromMap(data);

      final currentExams = room.exams;
      final members = room.membersInRoom ?? {};

      if (!currentExams.contains(examId)) {
        currentExams.add(examId);
      }

      // Always create safe empty list for students
      members[examId] = members[examId] ?? [];

      await docRef.update({
        "exams": currentExams,
        "membersInRoom": members.map(
          (key, value) => MapEntry(key, value.map((s) => s.toMap()).toList()),
        ),
      });

      log("Exam added to room successfully.");
    } catch (e) {
      log("Error adding exam to room: $e");
    }
  }
}
