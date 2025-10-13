import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo;
 AuthProvider(this._authRepo);
}