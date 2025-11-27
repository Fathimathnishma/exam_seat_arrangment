
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view/on_boarding/on_boarding1_sreen.dart';
import 'package:bca_exam_managment/features/view/student/students_entry_Screen.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bca_exam_managment/core/utils/app_colors.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  double _opacity = 0.0;

  
  @override
void initState() {
  super.initState();

  // Fade-in immediately
 Future.delayed(const Duration(milliseconds: 100), () {
  if (mounted) setState(() => _opacity = 1.0);
});

// Delay navigation
WidgetsBinding.instance.addPostFrameCallback((_) async {
  await Future.delayed(const Duration(seconds: 3)); // splash duration
  await _initializeApp();
});


}

Future<void> _initializeApp() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  try {
    auth.setTodayDate();

    // 🔍 Check User Status
    final result = await auth.checkUserStatus();

    if (!mounted) return;

    if (result != null) {
      final String userType = result["type"];

      // 🔥 Redirect based on type
      if (userType == "student") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentsEntryScreen()),
        );
      } 
      else if (userType == "Teacher" || userType == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppRoot()),
        );
      } 
    } 
    else {
      // 🟦 No user → Go to OnBoarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    }

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing app: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(
          "assets/images/app-logo.png",
            height: 300,
          ),
              Text(
                "EduSeat",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
