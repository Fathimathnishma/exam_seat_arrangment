import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/service/auth_services.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserModel?> addUser(UserModel user) {
    return _authService.signUpWithEmail(userModel: user);
  }

  Future<UserModel?> login(String email, String password) {
    return _authService.loginWithEmail(email: email, password: password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<void> deleteAccount() {
    return _authService.deleteUserAccount();
  }

  /// 🔹 Fetch current user if logged in
  Future<UserModel?> fetchCurrentUser() {
    return _authService.fetchCurrentUser();
  }
}
