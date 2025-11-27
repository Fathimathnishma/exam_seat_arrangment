import 'dart:developer';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

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
  try {
    // ⚡ Create a secondary Firebase app (does NOT affect main login)
    final secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );

    // ⚡ Create a separate auth instance
    final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

    // ⚡ Create teacher/admin WITHOUT logging out current admin
    UserCredential credential =
        await secondaryAuth.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );

    final uid = credential.user!.uid;

    final updatedUser = userModel.copyWith(id: uid);

    // ⚡ Save teacher/admin details in Firestore
    await usersRef.doc(uid).set(updatedUser.toMap());

    // ⚡ Cleanup secondary auth
    await secondaryAuth.signOut();
    await secondaryApp.delete();

    return updatedUser;
  } catch (e) {
    log("❌ Error adding admin/teacher: $e");
    return null;
  }
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
  // Future<List<StudentsModel>> fetchCurrentStudentUser() async {
  //   final query = await studentsRef.get();
  //   return query.docs.map((doc) {
  //     return StudentsModel.fromMap(doc.data() as Map<String, dynamic>);
  //   }).toList();
  // }

/// 🔹 Fetch Seat + Room Details
Future<Map<String, dynamic>?> fetchSeatAndRoom({
  required String regNo,
  required String department,
  required String sem,
}) async {
  try {
    log("🔍 Starting fetchSeatAndRoom()");
    log("📝 Inputs => regNo: $regNo | dept: $department | sem: $sem");

    // -----------------------------------------------------------
    // 1) FETCH EXAM
    // -----------------------------------------------------------
    final examQuery = await _firestore
        .collection('exams')
        .where('department', isEqualTo: department)
        .where('sem', isEqualTo: sem)
        .get();

    if (examQuery.docs.isEmpty) {
      log("❌ No exam found for dept+sem");
      return null;
    }

    final examDoc = examQuery.docs.first;
    final examId = examDoc.id;

    log("📌 Exam ID found: $examId");

    // -----------------------------------------------------------
   // -----------------------------------------------------------
// 1B) APPLY 15-MINUTE RULE (startTime is STRING -> e.g "10:00 AM")
// -----------------------------------------------------------
final examData = examDoc.data();
final startTimeString = examData['startTime']; // String like "10:00 AM"

if (startTimeString == null) {
  log("⚠️ Missing startTime in exam document");
  return null;
}

final now = DateTime.now();

// Convert string "10:00 AM" → DateTime object (time only)
final parsedTime = DateFormat("hh:mm a").parse(startTimeString);

// Attach today's date
final examDateTime = DateTime(
  now.year,
  now.month,
  now.day,
  parsedTime.hour,
  parsedTime.minute,
);

final minutesRemaining = examDateTime.difference(now).inMinutes;

log("⏳ Minutes remaining for exam: $minutesRemaining");

// BLOCK IF MORE THAN 15 MIN REMAINING
if (minutesRemaining > 15) {
  log("❌ Too early to show seat");
   return {
    "allowed": false,
    "message": "Seat will be visible only 15 minutes before the exam.",
    "minutesRemaining": minutesRemaining,
  };
}

    // -----------------------------------------------------------
    // 2) FETCH ROOMS THAT CONTAIN THIS EXAM
    // -----------------------------------------------------------
    final roomsQuery = await _firestore
        .collection('Rooms')
        .where('exams', arrayContains: examId)
        .get();

    if (roomsQuery.docs.isEmpty) {
      log("❌ No rooms contain this exam");
      return null;
    }

    // -----------------------------------------------------------
    // 3) CHECK EACH ROOM FOR THE STUDENT'S SEAT
    // -----------------------------------------------------------
    for (final roomDoc in roomsQuery.docs) {
      final roomData = roomDoc.data();
      final roomId = roomDoc.id;

      log("🏫 Checking Room: $roomId");

      final allSeats = roomData['allSeats'];

      if (allSeats is! List || allSeats.isEmpty) {
        log("⚠️ Room $roomId has no valid allSeats list");
        continue;
      }

      // -----------------------------------------------------------
      // 4) CHECK EACH SEAT FOR MATCHING regNo
      // -----------------------------------------------------------
      for (int i = 0; i < allSeats.length; i++) {
        final seat = allSeats[i];

        if (seat is! Map) continue;
        final student = seat['student'];
        if (student is! Map) continue;

        final foundRegNo = student['regNo'];

        if (foundRegNo == regNo) {
          log("✅ Student found in Room $roomId at seat index $i");

          final roomCode =
              roomData["roomNo"] ?? roomData[""] ?? "N/A";

          final roomName =
              roomData["roomName"] ?? roomData["name"] ?? "N/A";

          // FINAL RETURN WITH 15-MINUTE RULE PASSED + ROOM INFO
          return {
            "allowed": true, // seat can be shown now
            "examId": examId,
            "roomId": roomId,
            "roomCode": roomCode,
            "roomName": roomName,
            "seatData": {
              "seatNo": i + 1,
              "exam": seat['exam'],
              "color": seat['color'],
              "student": student,
            },
            "roomData": {
              ...roomData,
              "roomCode": roomCode,
              "roomName": roomName,
            },
          };
        }
      }

      log("❌ Student not in room: $roomId");
    }

    log("❌ Student not found in ANY room");
    return null;

  } catch (e, st) {
    log("🔥 ERROR in fetchSeatAndRoom(): $e");
    log("📌 STACKTRACE: $st");
    return null;
  }
}


  Future<bool> deleteUserAccount(String userId) async {
  try {
    if (userId.isEmpty) return false;

    // Convert uppercase → lowercase
    final cleanId = userId.trim().toLowerCase();

    // Check user exists
    final doc = await usersRef.doc(cleanId).get();

    if (!doc.exists) {
      log("❌ No user found with ID: $cleanId");
      return false; // <-- very important
    }

    final userData = doc.data();

    // Delete user
    await usersRef.doc(cleanId).delete();

    log("✅ User deleted: $cleanId, data: $userData");

    return true; // success

  } catch (e) {
    log("🔥 Error deleting user $userId: $e");
    return false; // fail
  }
}
  Future<bool> deleteStudentAccount(String studentId) async {
  try {
    if (studentId.isEmpty) return false;

    // Convert uppercase → lowercase
    final cleanId = studentId.trim().toLowerCase();

    // Check user exists
    final doc = await studentsRef.doc(cleanId).get();

    if (!doc.exists) {
      log("❌ No user found with ID: $cleanId");
      return false; // <-- very important
    }

    final userData = doc.data();

    // Delete user
    await studentsRef.doc(cleanId).delete();

    log("✅ User deleted: $cleanId, data: $userData");

    return true; // success

  } catch (e) {
    log("🔥 Error deleting user $studentId: $e");
    return false; // fail
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
