import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo;

  UserModel? currentUser;
  bool isLoading = false;

  AuthProvider(this._authRepo);

  /// 🔹 Check if user is already logged in
  Future<void> checkUserStatus() async {
    isLoading = true;
    notifyListeners();

    currentUser = await _authRepo.fetchCurrentUser();

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Register
  Future<void> register(UserModel user) async {
    isLoading = true;
    notifyListeners();

    currentUser = await _authRepo.addUser(user);

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Login
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    currentUser = await _authRepo.login(email, password);

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _authRepo.logout();
    currentUser = null;
    notifyListeners();
  }

  /// 🔹 Delete account
  Future<void> deleteAccount() async {
    await _authRepo.deleteAccount();
    currentUser = null;
    notifyListeners();
  }
}
