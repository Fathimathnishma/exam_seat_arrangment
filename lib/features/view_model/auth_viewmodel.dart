import 'dart:developer';
import 'package:bca_exam_managment/core/widgets/custom_fluttertoast.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo;

  AuthProvider(this._authRepo);

  String _todayDate = '';
  UserModel? currentUser; 
  StudentsModel? currentStudentUser; // <-- Already existed
  bool isLoading = false;
  Map<String, dynamic>? _seatDetails;
  List<UserModel> users = [];

  Map<String, dynamic>? get seatDetails => _seatDetails;

  /// 🔹 Set today’s date
  void setTodayDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('yyyy-MM-dd').format(now);
    debugPrint("Today's Date (from provider): $_todayDate");
  }

  /// 🔹 Check if user is already logged in
  Future<UserModel?> checkUserStatus() async {
    try {
      isLoading = true;
      notifyListeners();

      currentUser = await _authRepo.fetchCurrentUser();

      if (currentUser != null) {
        log("👤 Current user fetched: ${currentUser!.email}");
      }

      return currentUser;
    } catch (e) {
      showCustomToast(message: 'Failed to check user status: $e', isError: true);
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
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _authRepo.studentSignUp(
        name: name,
        studentId: studentId,
        password: password,
      );

     if (result != null) {
        currentStudentUser = StudentsModel(
          sem:result["sem"] ,
          department: result["department"],
          regNo: result["regNo"],
          name: result["name"],
           createdAt: result["createdAt"],
        );

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
          sem:result["sem"] ,
          department: result["department"],
          regNo: result["regNo"],
          name: result["name"],
           createdAt: result["createdAt"],
        );

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
      currentStudentUser = null;

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

  /// 🔹 Fetch Seat Details
  Future<void> fetchSeatDetails({
    required String regNo,
    required String department,
    required DateTime todayDate,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      _seatDetails = await _authRepo.fetchSeatAndRoom(
        regNo: regNo,
        department: department,
        todayDate: todayDate,
      );

      if (_seatDetails != null && _seatDetails!.isNotEmpty) {
        showCustomToast(message: 'Seat details loaded!');
      } else {
        showCustomToast(message: 'No seat details found.', isError: true);
      }
    } catch (e) {
      showCustomToast(message: 'Error fetching seat details: $e', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
