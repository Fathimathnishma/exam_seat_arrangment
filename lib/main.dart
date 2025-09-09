// import 'package:bca_exam_managment/core/utils/app_font.dart';
// import 'package:bca_exam_managment/features/view/splash_screens.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Lock device orientation to portrait
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   // Enable edge-to-edge screen and transparent status bar
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent, // makes status bar transparent
//       statusBarIconBrightness: Brightness.light, // white icons
//       systemNavigationBarColor:
//           Colors.transparent, // transparent bottom nav bar
//       systemNavigationBarIconBrightness: Brightness.light, // white icons
//     ),
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreens(),
//     );
//   }
// }
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view/splash_screens.dart';
import 'package:bca_exam_managment/features/view/teachers/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force full screen behind notch
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Make status bar & nav bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // for Android
      statusBarBrightness: Brightness.dark, // for iOS
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreens(),
    );
  }
}
