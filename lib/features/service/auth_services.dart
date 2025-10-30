import 'dart:developer';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Sign up user and store details in Firestore
  Future<UserModel?> signUpWithEmail({
  required UserModel userModel
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      final user = credential.user;
      if (user != null) {
        // Create user model

        // Add to Firestore
        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
        log("✅ User added successfully: ${user.email}");

        return userModel;
      }
    } catch (e) {
      log("🔥 Error signing up user: $e");
    }
    return null;
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
          return UserModel.fromMap(doc.data()!);
        }
      }
    } catch (e) {
      log("🔥 Login Error: $e");
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
  Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete from Firebase Auth
        await user.delete();

        log("🗑️ User account deleted successfully: ${user.email}");
      } else {
        log("⚠️ No user is currently logged in.");
      }
    } catch (e) {
      log("🔥 Error deleting user account: $e");
    }
  }
}
