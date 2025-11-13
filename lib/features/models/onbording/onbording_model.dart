import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingModel {
  // ignore_for_file: public_member_api_docs, sort_constructors_first
  String title;
  String description;
  String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

//LOCAL DATA

class OnboardingLocalData {
  static List<OnboardingModel> list = [
    OnboardingModel(
      title: 'Simplify Exam Seating Management',
      description:
          'Let technology handle it all. The app ensures every student gets the right spot — no overlaps, no mix-ups, just a fair plan every time.',
      image: AppImages.onbording_1,
    ),
    OnboardingModel(
      title: 'Automatic & Error-Free Seat Allocation',
      description:
          'Sit back and let the app handle it. Every student gets the right spot — no overlaps, no mix-ups, just a fair setup every time',
      image: AppImages.onbording_2,
    ),
    OnboardingModel(
      title: 'Real-Time Access for Students & Staff',
      description:
          'Let the app do the work. Students get the right spot — no overlaps, no mix-ups, just a fair plan every time.',
      image: AppImages.onbording_3,
    ),
  ];

  static Future<void> readOnBoardingScreen() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('isReadOnboardingScreen', true);
  }

  static Future<bool> getOnBoardingScreen() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool('isReadOnboardingScreen') ?? false;
  }
}
