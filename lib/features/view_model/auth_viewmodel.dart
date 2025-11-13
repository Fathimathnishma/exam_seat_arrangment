import 'dart:developer';

import 'package:bca_exam_managment/core/widgets/custom_fluttertoast.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view/teachers/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo;

  AuthProvider(this._authRepo);


  String _todayDate = '';
  UserModel? currentUser;
  bool isLoading = false;
  Map<String, dynamic>? _seatDetails;
  List<UserModel>users=[];
  Map<String, dynamic>? get seatDetails => _seatDetails;

  /// 🔹 Set today’s date
  void setTodayDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('yyyy-MM-dd').format(now);
    debugPrint("Today's Date (from provider): $_todayDate");
  }

  /// 🔹 Check if user is already logged in
  /// 🔹 Check if user is already logged in and return the user
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
    showCustomToast(message: 'Failed to check user status: $e', isError: true);
   
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
        message: 'Email already in use. Please try logging in.',
        isError: true,
      );
    } else if (errorMsg.contains('invalid-email')) {
      showCustomToast(
        message: 'Invalid email format. Please check and try again.',
        isError: true,
      );
    } else if (errorMsg.contains('weak-password')) {
      showCustomToast(
        message: 'Password is too weak. Please choose a stronger one.',
        isError: true,
      );
    } else {
      showCustomToast(
        message: 'Adding user failed. Please try again later.',
        isError: true,
      );
    }
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  /// 🔹 Login
 Future<void> login(String email, String password) async {
  try {
    isLoading = true;
    notifyListeners();

    final user = await _authRepo.login(email, password);

    if (user != null) {
      currentUser = user;
      showCustomToast(message: 'Login successful!');
    } else {
      showCustomToast(
        message: '⚠️ Login failed. Please check your connection or credentials.',
        isError: true,
      );
      log("⚠️ Auth repo returned null user.");
    }
  } on Exception catch (e) {
    String errorMsg = e.toString().toLowerCase();

    if (errorMsg.contains('network-request-failed')) {
      showCustomToast(
        message: '⚠️ Please connect to the internet and try again.',
        isError: true,
      );
      log("🌐 Network Error: No internet connection or Firebase unreachable.");
    } else if (errorMsg.contains('user-not-found')) {
      showCustomToast(message: 'No account found for this email.', isError: true);
    } else if (errorMsg.contains('wrong-password')) {
      showCustomToast(message: 'Incorrect password. Try again.', isError: true);
    } else {
      showCustomToast(message: 'Login failed: $e', isError: true);
      log("🔥 Unexpected login error: $e");
    }
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

    // Call the onSuccess callback if provided
    if (onSuccess != null) {
      onSuccess();
    }
  } catch (e) {
    showCustomToast(message: 'Failed to logout: $e', isError: true);
  } finally {
    notifyListeners();
  }
}


  /// 🔹 Delete Account
  Future<void> deleteAccount({VoidCallback? onSuccess ,required String userId}) async {
    try {
      await _authRepo.deleteAccount(userId);
      currentUser = null;
      showCustomToast(message: 'Account deleted successfully!');
      if (onSuccess != null) {
      onSuccess();
    }
    } catch (e) {
      showCustomToast(message: 'Failed to delete account: $e', isError: true);
    }
    notifyListeners();
  }

  Future<void> deleteTeacher({VoidCallback? onSuccess ,required String userId}) async {
    try {
      await _authRepo.deleteAccount(userId);
      currentUser = null;
      showCustomToast(message: 'Account deleted successfully!');
      if (onSuccess != null) {
      onSuccess();
    }
    } catch (e) {
      showCustomToast(message: 'Failed to delete account: $e', isError: true);
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
        showCustomToast(message: 'Seat details loaded successfully!');
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
