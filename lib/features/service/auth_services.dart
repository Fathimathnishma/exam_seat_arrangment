import 'dart:developer';
import 'package:bca_exam_managment/core/widgets/custom_fluttertoast.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Sign up user and store details in Firestore
Future<UserModel?> addUserByAdmin({
  required UserModel userModel,
}) async {
  try {
    // Save current admin UID (optional, if you want to restore later)
    final adminUser = _auth.currentUser;

    // Step 1: Create new user in Firebase Auth
    final credential = await _auth.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );

    final newUser = credential.user;
    if (newUser != null) {
      // Step 2: Create UserModel with Firebase UID
      final newUserModel = userModel.copyWith(id: newUser.uid);

      // Step 3: Add new user to Firestore
      await _firestore.collection('users').doc(newUser.uid).set(newUserModel.toMap());
      log("✅ User added successfully by admin: ${newUser.email}");

      // Step 4: Sign out new user to restore admin session
      await _auth.signOut();

      // Step 5: Sign back in as admin
      if (adminUser != null) {
        // You must know admin email & password to sign back in
        await _auth.signInWithEmailAndPassword(
          email: adminUser.email!,
          password: "adminPasswordHere", // secure way required
        );
      }

      // Step 6: Return the UserModel (not Firebase User)
      return newUserModel;
    }
  } catch (e) {
    log("🔥 Error adding user by admin: $e");
    rethrow;
  }

  return null;
}
///fetch all users
///
Future<List<UserModel>> fetchAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      log('🔥 Error fetching users: $e');
      return [];
    }
  }

  /// 🔹 Login existing user
  Future<UserModel?> loginWithEmail({
  required String email,
  required String password,
}) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final userModel = UserModel.fromMap(doc.data()!);
        log("✅ Login successful: ${user.email}");
        return userModel; // ✅ only success here
      } else {
        log("⚠️ Firestore document not found for user: ${user.uid}");
        // ❌ don't show login success
       
        return null;
      }
    }
  } catch (e) {
    log("🔥 Login Error: $e");
   rethrow;
  }

  return null;
}

  ///fetch user
  Future<UserModel?> fetchCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        log("👤 Current user fetched: ${user.email}");
        return UserModel.fromMap(doc.data()!);
      }
    }
  } catch (e) {
    log("🔥 Fetch current user error: $e");
  }
  return null;
}


  /// 🔹 Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      log("👋 User logged out successfully");
    } catch (e) {
      log("🔥 Logout Error: $e");
    }
  }

  /// 🔹 Delete user account (Auth + Firestore)
  Future<void> deleteUserAccount(String userId) async {
  try {
    final user = _auth.currentUser;
    if (user == null) {
      log("⚠️ No user is currently logged in.");
      return;
    }

    // Fetch user doc
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      log("⚠️ User not found in Firestore.");
      return;
    }

    final userData = userDoc.data()!;
    final role = userData['role'];

    // ✅ If user is admin, check if they’re the last one
    if (role == 'admin') {
      final adminSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (adminSnapshot.docs.length == 1) {
        log("🚫 Cannot delete the last admin. Add a new admin first.");
        throw Exception("Cannot delete the last admin. Please add another admin first.");
      }
    }

    // ✅ Delete from Firestore
    await _firestore.collection('users').doc(user.uid).delete();

    // ✅ Delete from Firebase Auth
    await user.delete();

    log("🗑️ User account deleted successfully: ${user.email}");
  } catch (e) {
    log("🔥 Error deleting user account: $e");
    rethrow; // rethrow so the UI can show an error dialog/snackbar
  }
}
  Future<void> deleteteacher(String userId) async {
  try {
  
    // Fetch user doc
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      log("⚠️ User not found in Firestore.");
      return;
    }

    final userData = userDoc.data()!;
    final role = userData['role'];

    // ✅ If user is admin, check if they’re the last one
    if (role == 'admin') {
      final adminSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      if (adminSnapshot.docs.length == 1) {
        log("🚫 Cannot delete the last admin. Add a new admin first.");
        throw Exception("Cannot delete the last admin. Please add another admin first.");
      }
    }

    // ✅ Delete from Firestore
    await _firestore.collection('users').doc(userId).delete();

    

    
  } catch (e) {
    log("🔥 Error deleting user account: $e");
    rethrow; // rethrow so the UI can show an error dialog/snackbar
  }
}

  //fetch student details
   Future<Map<String, dynamic>?> getSeatAndRoomDetails({
    required String regNo,
    required String department,
    required DateTime todayDate,
  }) async {
    try {
      // Step 1: Get today's exam for the department
      QuerySnapshot examSnapshot = await _firestore
          .collection('exams')
          .where('department', isEqualTo: department)
          .where('date', isEqualTo: todayDate.toIso8601String().split('T')[0])
          .get();

      if (examSnapshot.docs.isEmpty) return null;

      // Step 2: Get the examId
      var examData = examSnapshot.docs.first;
      String examId = examData.id;

      // Step 3: Find room that contains this examId
      QuerySnapshot roomSnapshot = await _firestore
          .collection('Rooms')
          .where('examId', isEqualTo: examId)
          .get();

      if (roomSnapshot.docs.isEmpty) return null;

      // Step 4: Search the student's seat by regNo
      for (var room in roomSnapshot.docs) {
        List seatArrangements = room['seatArrangements'] ?? [];
        var seat = seatArrangements.firstWhere(
          (s) => s['regNo'] == regNo,
          orElse: () => null,
        );

        if (seat != null) {
          return {
            'roomId': room.id,
            'roomName': room['name'] ?? '',
            'seatNo': seat['seatNo'],
            'exam': examData.data(),
          };
        }
      }

      return null;
    } catch (e) {
      print("Error fetching seat details: $e");
      return null;
    }
  }
}
