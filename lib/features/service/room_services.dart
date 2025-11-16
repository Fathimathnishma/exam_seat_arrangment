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
  Future<void> deleteRoom(String roomId) async {
    try {
      await firebase.doc(roomId).delete();
      log("Room deleted successfully: $roomId");
    } catch (e) {
      log("Error while deleting room: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // ASSIGN STUDENTS TO ROOM
  // ---------------------------------------------------------------------------
//   Future<void> assignStudentsToRoom({
//   required ExamModel exam,
//   required String roomId,
//   required int count,
// }) async {
//   try {
//     log("=== SERVICE assignStudentsToRoom START ===");

//     // 1. Get duplicate students
//     final dupStudents = exam.duplicatestudents ?? [];
//     log("Duplicate students: ${dupStudents.map((s) => s.regNo).toList()}");

//     if (dupStudents.isEmpty || count <= 0) {
//       log("❌ No duplicates or invalid count");
//       return;
//     }

//     // 2. Fetch room
//     final roomSnap = await firebase.doc(roomId).get();
//     if (!roomSnap.exists) {
//       log("❌ Room not found: $roomId");
//       return;
//     }

//     final roomData = roomSnap.data()!;
//     roomData["id"] = roomSnap.id;
//     final room = RoomModel.fromMap(roomData);

//     final members = room.membersInRoom;
//     final existingList = members[exam.examId] ?? [];

//     // 3. Remove already assigned
//     final cleanDuplicateList = dupStudents.where((s) =>
//         !existingList.any((m) => m.regNo == s.regNo)).toList();

//     if (cleanDuplicateList.isEmpty) {
//       log("⚠ All duplicate students are already assigned.");
//       return;
//     }

//     // 4. Apply safe count (cannot exceed list)
//     final safeCount =
//         count > cleanDuplicateList.length ? cleanDuplicateList.length : count;

//     final selected = cleanDuplicateList.take(safeCount).toList();
//     final remaining = cleanDuplicateList.skip(safeCount).toList();

//     log("Selected for assignment: ${selected.map((s) => s.regNo).toList()}");
//     log("Remaining after assignment: ${remaining.map((s) => s.regNo).toList()}");

//     // 5. Add selected students to room
//     existingList.addAll(selected);

//     // Deduplicate again (safety)
//     final updatedList = {
//       for (var s in existingList) s.regNo: s,
//     }.values.toList();

//     members[exam.examId!] = updatedList;

//     log("Final list in room: ${updatedList.map((s) => s.regNo).toList()}");

//     // 6. Commit updates to Firebase
//     final batch = firestore.batch();

//     batch.update(firebase.doc(roomId), {
//       "membersInRoom": members.map(
//         (key, value) => MapEntry(
//           key,
//           value.map((s) => s.toMap()).toList(),
//         ),
//       ),
//     });

//     batch.update(examCollection.doc(exam.examId), {
//       "duplicatestudents": remaining.map((s) => s.toMap()).toList(),
//     });

//     await batch.commit();

//     log("SERVICE: Students assigned successfully!");
//     log("=== SERVICE assignStudentsToRoom END ===");

//   } catch (e) {
//     log("❌ ERROR in SERVICE assignStudentsToRoom: $e");
//   }
// }


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
