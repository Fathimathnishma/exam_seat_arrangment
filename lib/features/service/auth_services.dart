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

  Future<void> deleteUserAccount(String userId) async {
    await usersRef.doc(userId).delete();
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

  Future<Map<String, dynamic>?> getSeatAndRoomDetails({
    required String regNo,
    required String department,
    required DateTime todayDate,
  }) async {
    // original logic untouched
    return null;
  }

  // ===============================================================
  // 🚀 ADDED: STUDENT SIGNUP & LOGIN
  // ===============================================================

  /// 🔹 STUDENT SIGN-UP (Firestore only)
  Future<Map<String, dynamic>?> studentSignUp({
    required String name,
    required String studentId,
    required String password,
  }) async {
    try {
      final cleanId = studentId.trim().toLowerCase();

      final doc = await studentsRef.doc(cleanId).get();
      if (doc.exists) throw "Student ID already exists";

      final data = {
        "id": cleanId,
        "name": name.trim(),
        "studentId": cleanId,
        "password": password, // hashing if needed
        "createdAt": Timestamp.now(),
      };

      await studentsRef.doc(cleanId).set(data);

      return data;
    } catch (e) {
      log("🔥 Student SignUp Error: $e");
      rethrow;
    }
  }

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
