
class RoomModel {
  String? roomName;
  String roomNo;
  int capacity;
  List exams;
  String? layout;
  String? id;
  RoomModel({
    this.roomName,
    required this.roomNo,
    required this.capacity,
    required this.exams,
    this.layout,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomName': roomName,
      'roomNo': roomNo,
      'capacity': capacity,
      'exams': exams,
      'layout': layout,
      'id': id,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
  return RoomModel(
    roomName: map['roomName'] != null ? map['roomName'] as String : null,
    roomNo: map['roomNo'] as String,
    capacity: map['capacity'] as int,
    exams: map['exams'] != null ? List.from(map['exams'] as List) : [],
    layout: map['layout'] != null ? map['layout'] as String : null,
    id: map['id'] != null ? map['id'] as String : null,
  );
}


 

}
