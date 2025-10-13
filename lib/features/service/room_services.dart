import 'dart:developer';

import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomService {
  final firestore = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance.collection("Rooms");

  Future<void> addRoom(RoomModel roomModel) async {
    try {
      final id = firebase.doc().id;
      final roomRef = firebase.doc(id);
      final room = roomModel.copyWith(id: id);

      final batch = firestore.batch();

      batch.set(roomRef, room.toMap());

      await batch.commit();

      log("Room added successfully with ID: $id");
    } catch (e) {
      log("Error while adding room: $e");
    }
  }

  Future<List<RoomModel>> fetchRooms() async {
    try {
      final querySnapshot = await firebase.get();
      final rooms =
          querySnapshot.docs
              .map((doc) => RoomModel.fromMap(doc.data()))
              .toList();

      log("Fetched ${rooms.length} rooms");
      return rooms;
    } catch (e) {
      log("Error while fetching rooms: $e");
      return [];
    }
  }

  Future<void> updateRoom(RoomModel roomModel) async {
    try {
      await firebase.doc(roomModel.id).update(roomModel.toMap());
      log("Room updated successfully: ${roomModel.id}");
    } catch (e) {
      log("Error while updating room: $e");
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await firebase.doc(roomId).delete();
      log("Room deleted successfully: $roomId");
    } catch (e) {
      log("Error while deleting room: $e");
    }
  }
}
