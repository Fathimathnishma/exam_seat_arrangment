import 'package:bca_exam_managment/core/utils/app_font.dart';
import 'package:bca_exam_managment/features/view/splash_screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: FontConstants.Manrope),

      home: SplashScreens(),
    );
  }
}
