import 'package:bca_exam_managment/features/repo/auth_repo.dart';
import 'package:bca_exam_managment/features/repo/exam_repo.dart';
import 'package:bca_exam_managment/features/repo/room_repo.dart';
import 'package:bca_exam_managment/features/service/auth_services.dart';
import 'package:bca_exam_managment/features/service/exam_services.dart';
import 'package:bca_exam_managment/features/service/room_services.dart';
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view/splash_screens.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/home_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/room_viewodel.dart';
import 'package:bca_exam_managment/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExamProvider(ExamRepository(ExamService())),
        ),
        ChangeNotifierProvider(
          create: (context) => RoomProvider(RoomRepository(RoomService()),ExamRepository(ExamService())),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthRepository(AuthService())),
        ),
        ChangeNotifierProvider(create: (context) => HomeProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
       // home: AppRoot(),
         home: SplashScreens(),
      ),
    );
  }
}
