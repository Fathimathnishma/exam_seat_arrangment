import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/service/room_services.dart';

class RoomRepository {
  final RoomService _roomService;

  RoomRepository(this._roomService);

  /// Add room
  Future<void> addRoom(RoomModel room) {
    return _roomService.addRoom(room);
  }

  /// Fetch all rooms once
  Future<List<RoomModel>> fetchRooms() {
    return _roomService.fetchRooms();
  }

  /// Update room
  Future<void> updateRoom(RoomModel room) {
    return _roomService.updateRoom(room);
  }
//assignStudentsToRoom
Future<void> assignStudentsToRoom({
    required ExamModel exam,
    required String roomId,
    required int count,}){
      return _roomService.assignStudentsToRoom(exam: exam, roomId: roomId, count: count);
    }

    ///addExamToRoom
  Future<void>addExamToRoom(String rooomid,String examId){
    return _roomService.addExamToRoom(rooomid, examId);
  }

  /// Delete room
  Future<void> deleteRoom(String roomId) {
    return _roomService.deleteRoom(roomId);
  }
 
}
