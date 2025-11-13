import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast({
  required String message,
  bool isError = false,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.red : AppColors.primary,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
