import 'dart:developer';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference collection
  CollectionReference get usersRef => _firestore.collection("users");
  CollectionReference get studentsRef => _firestore.collection("students");

  // ===============================================================
  // 🔹 EXISTING ADMIN METHODS (UNTOUCHED)
  // ===============================================================

  Future<UserModel?> addUserByAdmin({required UserModel userModel}) async {
    await usersRef.doc(userModel.id).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await usersRef.doc(credential.user!.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> deleteSelfAccount() async {
  final user = _auth.currentUser;
  if (user == null) return;

  try {
    // Delete Firestore doc
    await usersRef.doc(user.uid).delete();
    log("✅ Deleted Firestore doc for self: ${user.uid}");

    // Delete Auth account
    await user.delete();
    log("✅ Deleted Auth account for self: ${user.uid}");
  } catch (e) {
    log("🔥 Error deleting self account: $e");
    rethrow;
  }
}


  Future<UserModel?> fetchCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snap = await usersRef.doc(user.uid).get();
    if (!snap.exists) return null;

    return UserModel.fromMap(snap.data() as Map<String, dynamic>);
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final query = await usersRef.get();
    return query.docs.map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

Future<Map<String, dynamic>?> getStudentSeatDetails({
  required String regNo,
  required String department,
  required String sem,
}) async {
  final firestore = FirebaseFirestore.instance;

  print("🔍 Starting student seat search...");
  print("➡ regNo: $regNo");
  print("➡ department: $department");
  print("➡ sem: $sem");

  // 1. Load today's exams
  final today = DateTime.now();
  final start = DateTime(today.year, today.month, today.day);
  final end = start.add(const Duration(days: 1));

  print("📅 Searching exams between $start and $end");

  final examQuery = await firestore
      .collection("Exams")
      .where("department", isEqualTo: department)
      .where("sem", isEqualTo: sem)
      .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
      .where("date", isLessThan: Timestamp.fromDate(end))
      .get();

  print("📘 Exams found: ${examQuery.docs.length}");

  if (examQuery.docs.isEmpty) {
    print("❌ No exams found for today");
    return null;
  }

  // 2. Check each exam
  for (var examDoc in examQuery.docs) {
    final examData = examDoc.data();
    final examId = examDoc.id;

    print("----------------------------");
    print("📝 Checking Exam: $examId");
    print("Subject: ${examData["subject"]}");

    // Load all rooms
    final roomQuery = await firestore.collection("Rooms").get();
    print("🏫 Rooms found: ${roomQuery.docs.length}");

    for (var roomDoc in roomQuery.docs) {
      final roomData = roomDoc.data();

      print("➡ Checking Room: ${roomData["roomName"]}");

      final allSeats = roomData["allSeats"];

      if (allSeats == null || allSeats is! List) {
        print("⚠ Skipped room: allSeats is NULL or not a LIST");
        continue;
      }

      print("🪑 Seats in room: ${allSeats.length}");

      // Check each seat
      for (var seat in allSeats) {
        print("🔍 Checking seat: $seat");

        if (seat == null) continue;

        if (seat["examId"] != examId) {
          print("⛔ Seat examId mismatch: ${seat["examId"]}");
          continue;
        }

        if (seat["student"] == null) {
          print("⛔ Seat has NO STUDENT");
          continue;
        }

        final stud = seat["student"];

        print("👤 Student on this seat: ${stud["regNo"]}");

        if (stud["regNo"] == regNo) {
          print("🎉 MATCH FOUND!");
          print("Seat No: ${seat["seatNo"]}");
          print("Room: ${roomData["roomName"]}");

          return {
            "student": {
              "name": stud["name"],
              "regNo": stud["regNo"],
              "department": stud["department"],
              "sem": stud["sem"],
            },
            "exam": {
              "examId": examId,
              "subject": examData["subject"] ?? "",
              "date": examData["date"],
              "startTime": examData["startTime"],
              "endTime": examData["endTime"],
            },
            "room": {
              "roomId": roomDoc.id,
              "roomName": roomData["roomName"],
              "seatNo": seat["seatNo"],
            }
          };
        }
      }
    }
  }

  print("❌ No matching seat found in any room");
  return null;
}







  Future<void> deleteUserAccount(String userId) async {
  try {
    // Fetch user data before deletion for logging
    final doc = await usersRef.doc(userId).get();
    if (!doc.exists) {
      log("⚠️ Attempted to delete non-existing user: $userId");
      return;
    }

    final userData = doc.data();
    
    // Delete the user
    await usersRef.doc(userId).delete();
    
    // Log deleted user info
    log("✅ Admin deleted user: $userId, data: $userData");
  } catch (e) {
    log("🔥 Error deleting user $userId: $e");
    rethrow;
  }
}


  // ===============================================================
  // 🚀 ADDED: STUDENT SIGNUP & LOGIN
  // ===============================================================

  /// 🔹 STUDENT SIGN-UP (Firestore only)
/// 🔹 STUDENT SIGN-UP (Firestore)
Future<Map<String, dynamic>?> studentSignUp({
  required String name,
  required String studentId,
  required String password,
  required String department,
  required String sem,
}) async {
  try {
    final cleanId = studentId.trim().toLowerCase();

    // Check if already exists
    final doc = await studentsRef.doc(cleanId).get();
    if (doc.exists) throw "Student ID already exists";

    final data = {
      "studentId": cleanId,
      "regNo": cleanId,
      "name": name.trim(),
      "department": department,
      "sem": sem,
      "password": password,
      "createdAt": Timestamp.now(),
    };

    // SAVE using studentId as document ID
    await studentsRef.doc(cleanId).set(data);

    return data;
  } catch (e) {
    log("🔥 Student SignUp Error: $e");
    rethrow;
  }
}


  /// 🔹 STUDENT LOGIN
  /// 🔹 STUDENT LOGIN
Future<Map<String, dynamic>?> studentLogin({
  required String studentId,
  required String password,
}) async {
  try {
    final cleanId = studentId.trim().toLowerCase();

    final doc = await studentsRef.doc(cleanId).get();
    if (!doc.exists) throw "Student not found";

    final data = doc.data() as Map<String, dynamic>;

    if (data["password"] != password) throw "Invalid password";

    return data;
  } catch (e) {
    log("🔥 Student Login Error: $e");
    rethrow;
  }
}


}
