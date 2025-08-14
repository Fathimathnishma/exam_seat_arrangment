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
      title: 'Find your  Exam\n Class here',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
      image: AppImages.onbording_1,
    ),
    OnboardingModel(
      title: 'Make Payment',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
      image: AppImages.onbording_2,
    ),
    OnboardingModel(
      title: 'Get Your Order',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
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
