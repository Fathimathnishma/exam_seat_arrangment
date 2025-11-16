import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/service/auth_services.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // ===============================================================
  // 🔹 EXISTING ADMIN REPO METHODS (UNTOUCHED)
  // ===============================================================

  Future<UserModel?> addUser(UserModel user) {
    return _authService.addUserByAdmin(userModel: user);
  }

  Future<UserModel?> login(String email, String password) {
    return _authService.loginWithEmail(email: email, password: password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<void> deleteUserAccount(String userId) {
    return _authService.deleteUserAccount(userId);
  }
  Future<void> deleteSelfAccount( ) {
    return _authService.deleteSelfAccount();
  }

  Future<UserModel?> fetchCurrentUser() {
    return _authService.fetchCurrentUser();
  }

  Future<List<UserModel>> fetchAllUsers() {
    return _authService.fetchAllUsers();
  }

  Future<Map<String, dynamic>?> fetchSeatAndRoom({
    required String regNo,
    required String department,
    required DateTime todayDate,
  }) async {
    return await _authService.getSeatAndRoomDetails(
      regNo: regNo,
      department: department,
      todayDate: todayDate,
    );
  }

  // ===============================================================
  // 🚀 ADDED: STUDENT REPO METHODS
  // ===============================================================

  Future<Map<String, dynamic>?> studentSignUp({
    required String name,
    required String studentId,
    required String password,
  }) {
    return _authService.studentSignUp(
      name: name,
      studentId: studentId,
      password: password,
    );
  }

  Future<Map<String, dynamic>?> studentLogin({
    required String studentId,
    required String password,
  }) {
    return _authService.studentLogin(
      studentId: studentId,
      password: password,
    );
  }
}
