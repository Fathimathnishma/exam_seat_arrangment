import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/repo/room_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepo;

  RoomProvider(this._roomRepo);

  List<RoomModel> allRooms = [];
  bool isLoading = false;
  String? errorMessage;

  // CONTROLLERS
  TextEditingController roomName = TextEditingController();
  TextEditingController roomCode = TextEditingController();
  TextEditingController capacity = TextEditingController();

  // Layout dropdown selection
  String? selectedLayout;

  // To track whether we are updating an existing room
  String? updatingRoomId;

  /// Fetch rooms
  Future<void> fetchRooms() async {
    isLoading = true;
    notifyListeners();

    try {
      allRooms = await _roomRepo.fetchRooms();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Pre-fill controllers for updating
  void setRoomForUpdate(RoomModel room) {
    updatingRoomId = room.id;
    roomName.text = room.roomName ?? '';
    roomCode.text = room.roomNo;
    selectedLayout = room.layout; // ✅ pre-fill dropdown
    capacity.text = room.capacity.toString();
    notifyListeners();
  }

  /// Create RoomModel from controllers
  RoomModel get roomFromControllers => RoomModel(
    id: updatingRoomId,
    roomName: roomName.text.trim(),
    roomNo: roomCode.text.trim(),
    layout: selectedLayout ?? '', // ✅ use dropdown value
    capacity: int.tryParse(capacity.text.trim()) ?? 0,
    createdAt: Timestamp.now(),
  );

  /// Add or Update room
  Future<void> saveRoom() async {
    if (updatingRoomId == null) {
      await _addRoom();
    } else {
      await _updateRoom();
    }
  }

  Future<void> _addRoom() async {
    try {
      final room = roomFromControllers;
      await _roomRepo.addRoom(room);
      clearControllers();
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _updateRoom() async {
    try {
      final room = roomFromControllers;
      await _roomRepo.updateRoom(room);
      clearControllers();
      updatingRoomId = null;
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void deleteRoom(String roomId) async {
    try {
      await _roomRepo.deleteRoom(roomId);
      await fetchRooms();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearControllers() {
    roomName.clear();
    roomCode.clear();
    capacity.clear();
    selectedLayout = null; // ✅ reset dropdown
    updatingRoomId = null;
  }

  void clearData() {
    allRooms = [];
    isLoading = false;
    errorMessage = null;
    clearControllers();
    notifyListeners();
  }
}
