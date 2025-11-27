import 'dart:developer';
import 'package:bca_exam_managment/core/widgets/custom_fluttertoast.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo;

  AuthProvider(this._authRepo);

  String _todayDate = '';
  UserModel? currentUser; 
  StudentsModel? currentStudentUser; // <-- Already existed
  bool isLoading = false;
  Map<String, dynamic>? seatDetails;
  List<UserModel> users = [];
  List <StudentsModel>students=[];


  /// 🔹 Set today’s date
  void setTodayDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('yyyy-MM-dd').format(now);
    debugPrint("Today's Date (from provider): $_todayDate");
  }

  /// 🔹 Check if user is already logged in
Future<Map<String, dynamic>?> checkUserStatus() async {
  try {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    /// -----------------------------------------------------
    /// 🔥 1. CHECK STUDENT SESSION (SharedPreferences)
    /// -----------------------------------------------------
    final isStudentLoggedIn = prefs.getBool("isStudentLoggedIn") ?? false;

    if (isStudentLoggedIn) {
      final regNo = prefs.getString("studentId");
      final name = prefs.getString("studentName");
      final department = prefs.getString("department");
      final sem = prefs.getString("sem");

      if (regNo != null && name != null && department != null && sem != null) {
        currentStudentUser = StudentsModel(
          regNo: regNo,
          name: name,
          department: department,
          sem: sem,
          createdAt: Timestamp.now(),
        );

        log("🎓 Student logged in: $name");

        return {
          "type": "student",
          "data": currentStudentUser,
        };
      }
    }

    /// -----------------------------------------------------
    /// 🔥 2. CHECK FIREBASE USER (ADMIN / TEACHER)
    /// -----------------------------------------------------
    currentUser = await _authRepo.fetchCurrentUser();

    if (currentUser != null) {
      log("👤 Firebase user logged in: ${currentUser!.email}");

      return {
        "type": currentUser!.role,   // <-- role comes from UserModel
        "data": currentUser,
      };
    }

    /// -----------------------------------------------------
    /// ❌ 3. NO USER FOUND
    /// -----------------------------------------------------
    return null;

  } catch (e) {
    showCustomToast(message: "Failed to check login status: $e", isError: true);
    return null;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  Future<void> fetchusers() async {
    try {
      isLoading = true;
      notifyListeners();

      users = await _authRepo.fetchAllUsers();
    } catch (e) {
      showCustomToast(message: 'Failed to fetch users: $e', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUserByAdmin(UserModel user) async {
    try {
      isLoading = true;
      notifyListeners();

      final newUser = await _authRepo.addUser(user);

      if (newUser != null) {
        showCustomToast(
          message: 'User added successfully!',
          isError: false,
        );
      }
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();

      if (errorMsg.contains('email-already-in-use')) {
        showCustomToast(
          message: 'Email already in use.',
          isError: true,
        );
      } else if (errorMsg.contains('invalid-email')) {
        showCustomToast(
          message: 'Invalid email format.',
          isError: true,
        );
      } else if (errorMsg.contains('weak-password')) {
        showCustomToast(
          message: 'Password is too weak.',
          isError: true,
        );
      } else {
        showCustomToast(
          message: 'Adding user failed.',
          isError: true,
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================================================================
  /// 🚀 **ADDED: STUDENT SIGNUP**
  /// ================================================================
  Future<void> studentSignUp({
  required String name,
  required String studentId,
  required String password,
  required String department,
  required String sem,
}) async {
  try {
    isLoading = true;
    notifyListeners();

    final result = await _authRepo.studentSignUp(
      name: name,
      studentId: studentId,
      password: password,
      department: department,
      sem: sem,
    );

    if (result != null) {
      currentStudentUser = StudentsModel(
        sem: result["sem"],
        department: result["department"],
        regNo: result["regNo"],
        name: result["name"],
        createdAt: result["createdAt"],
      );

      /// 🔥 SAVE STUDENT SESSION IN SHARED PREFERENCES
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isStudentLoggedIn", true);
      await prefs.setString("studentId", result["regNo"]);
      await prefs.setString("studentName", result["name"]);
      await prefs.setString("department", result["department"]);
      await prefs.setString("sem", result["sem"]);

      showCustomToast(message: "Student registered successfully!");
    }
  } catch (e) {
    showCustomToast(message: "Signup failed: $e", isError: true);
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  /// ================================================================
  /// 🚀 **ADDED: STUDENT LOGIN**
  /// ================================================================
  Future<void> studentLogin({
  required String studentId,
  required String password,
}) async {
  try {
    isLoading = true;
    notifyListeners();

    final result = await _authRepo.studentLogin(
      studentId: studentId,
      password: password,
    );

    if (result != null) {
      currentStudentUser = StudentsModel(
        sem: result["sem"],
        department: result["department"],
        regNo: result["regNo"],
        name: result["name"],
        createdAt: result["createdAt"],
      );

      /// 🔥 SAVE STUDENT SESSION IN SHARED PREFERENCES
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isStudentLoggedIn", true);
      await prefs.setString("studentId", result["regNo"]);
      await prefs.setString("studentName", result["name"]);
      await prefs.setString("department", result["department"]);
      await prefs.setString("sem", result["sem"]);

      showCustomToast(message: "Student login successful!");
    }
  } catch (e) {
    showCustomToast(message: "Student login failed: $e", isError: true);
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  /// 🔹 Admin Login
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authRepo.login(email, password);

      if (user != null) {
        currentUser = user;
        showCustomToast(message: 'Login successful!');
      } else {
        showCustomToast(message: 'Login failed.', isError: true);
      }
    } catch (e) {
      showCustomToast(message: 'Login error: $e', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Logout
  Future<void> logout({VoidCallback? onSuccess}) async {
    try {
      await _authRepo.logout();
      currentUser = null;

      showCustomToast(message: 'Logged out successfully!');

      if (onSuccess != null) onSuccess();
    } catch (e) {
      showCustomToast(message: 'Failed to logout: $e', isError: true);
    } finally {
      notifyListeners();
    }
  }

  /// 🔹 Delete Account
  Future<void> deleteAccount({VoidCallback? onSuccess, }) async {
    try {
      await _authRepo.deleteSelfAccount();
      currentUser = null;

      showCustomToast(message: 'Account deleted successfully!');
      if (onSuccess != null) onSuccess();
    } catch (e) {
      showCustomToast(message: 'Failed to delete account: $e', isError: true);
    }
    notifyListeners();
  }

  Future<void> deleteTeacher({VoidCallback? onSuccess, required String userId}) async {
    try {
      await _authRepo.deleteUserAccount(userId);
      currentUser = null;

      showCustomToast(message: 'Teacher deleted!');
      if (onSuccess != null) onSuccess();
    } catch (e) {
      showCustomToast(message: 'Failed to delete teacher: $e', isError: true);
    }
    notifyListeners();
  }


/// 🔹 Student Logout (without clearing SharedPreferences)
Future<void> studentLogout({VoidCallback? onSuccess}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove("isStudentLoggedIn");
    await prefs.remove("studentId");
    await prefs.remove("studentName");
    await prefs.remove("department");
    await prefs.remove("sem");

    currentStudentUser = null;

    showCustomToast(message: 'Student logged out successfully!');

    if (onSuccess != null) onSuccess();
  } catch (e) {
    showCustomToast(message: 'Failed to logout student: $e', isError: true);
  } finally {
    notifyListeners();
  }
}


Future<bool> deleteStudentAccount() async {
  try {
    if (currentStudentUser == null) return false;

    // Call repo -> returns bool
    final deleted = await _authRepo.deleteStudentAccount(
      currentStudentUser!.regNo,
    );

    if (!deleted) {
      showCustomToast(
        message: 'Student not found! Cannot delete.',
        isError: true,
      );
      return false; // STOP HERE
    }

    // --------------------------------------------
    // DELETE SUCCESS → CLEAR LOCAL SESSION
    // --------------------------------------------
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isStudentLoggedIn");
    await prefs.remove("studentId");
    await prefs.remove("studentName");
    await prefs.remove("department");
    await prefs.remove("sem");

    currentStudentUser = null;

    showCustomToast(message: 'Student account deleted successfully!');

    notifyListeners();
    return true; // SUCCESS

  } catch (e) {
    showCustomToast(
      message: 'Failed to delete student account: $e',
      isError: true,
    );
    return false;
  }
}

  /// 🔹 Fetch Seat Details
Future<void> fetchSeatDetails({
  required String regNo,
  required String department,
  required String sem,
}) async {
  isLoading = true;
  notifyListeners();

  try {
    final cleanRegNo = regNo.trim();
    final cleanDept = department.trim();
    final cleanSem = sem.trim();

    final result = await _authRepo.fetchSeatAndRoom(
      regNo: cleanRegNo,
      department: cleanDept,
      sem: cleanSem,
    );

    // Store result 🔥 (IMPORTANT)
    seatDetails = result;

    // CASE 1 → No seat at all
    if (result == null) {
      showCustomToast(
        message: "No seat details found for this student",
        isError: true,
      );
      return;
    }

    // CASE 2 → Seat exists but NOT allowed to show yet
    if (result["allowed"] == false) {
      final msg = result["message"] ?? "Too early to view seat.";
      final remaining = result["minutesRemaining"] ?? 0;

      showCustomToast(
        message: "$msg ($remaining minutes remaining)",
        isError: true,
      );

      notifyListeners(); // 🔥 UPDATE UI
      return;
    }

    // CASE 3 → Success
    showCustomToast(message: "Seat details loaded!");
    log("Seat details loaded!");

  } catch (e) {
    log("SEAT FETCH ERROR: $e");
    showCustomToast(message: "Error fetching seat details", isError: true);
  } finally {
    isLoading = false;
    notifyListeners();
  }
}




}