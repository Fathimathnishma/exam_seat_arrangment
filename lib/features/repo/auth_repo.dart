import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/service/auth_services.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserModel?> addUser(UserModel user) {
    return _authService.addUserByAdmin(userModel: user);
  }

  Future<UserModel?> login(String email, String password) {
    return _authService.loginWithEmail(email: email, password: password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<void> deleteAccount(String userId) {
    return _authService.deleteUserAccount(userId);
  }

  /// 🔹 Fetch current user if logged in
  Future<UserModel?> fetchCurrentUser() {
    return _authService.fetchCurrentUser();
  }
  //fetch all users
  Future<List<UserModel>> fetchAllUsers() {
    return _authService.fetchAllUsers();
  }
  /// fetch students detail
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
}