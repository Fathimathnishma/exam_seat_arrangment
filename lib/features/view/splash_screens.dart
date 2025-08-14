import 'dart:developer';

import 'package:bca_exam_managment/features/models/onbording/onbording_model.dart';
import 'package:bca_exam_managment/features/view/on_boarding/on_boarding1_sreen.dart';
import 'package:flutter/material.dart';

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

    // Start fade-in effect
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to onboarding after delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    });
  }

  // void initState() {
  //   super.initState();
  //   // context.read<AuthenticationProvider>().fetchUser();
  //  // _initializeApp();
  //   // Start the fade-in animation
  //   Future.delayed(Duration(milliseconds: 500), () {
  //     setState(() {
  //       _opacity = 1.0;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 2), // Fade-in duration
          opacity: _opacity,
          child: Text("exam arrangment,", style: TextStyle(fontSize: 32)),
          // child: Image.asset(
          //  AppImages.eBookImage,
          //   height: 51,
          // )
        ),
      ),
    );
  }

  //Future<void> _initializeApp() async {
  //   // Wait for 3 seconds
  //   await Future.delayed(const Duration(seconds: 3));
  // if (mounted) {
  // final location = context.read<ProperitesProvider>();
  // final userModel = context.read<AuthenticationProvider>().userModel;

  // log(userModel?.id ??
  //     'nullrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr'.toString());
  // log('nullrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr'.toString());

  // final isReadOnBoardingScreen =
  //     await OnboardingLocalData.getOnBoardingScreen();

  // // if (!mounted) return;

  // //  ON BORDING
  // if (isReadOnBoardingScreen == false) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => OnBoardingScreen()),
  //   );
  //   //   // return;
  // }

  // //  LOGIN
  // if (userModel == null) {
  // EasyNavigation.pushAndRemoveUntil(
  //   context: context,
  //   page: const LoginScreens(),
  // );
  // return;
  // }

  // EasyNavigation.pushAndRemoveUntil(
  //   context: context,
  //   page: const AppRoot(),
  // );
}
