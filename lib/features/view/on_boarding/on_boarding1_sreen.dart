import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/onbording/onbording_model.dart';
import 'package:bca_exam_managment/features/view/on_boarding/widgets/onboarding_frame.dart';
import 'package:bca_exam_managment/features/view/user_type_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,

        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: () {
                OnboardingLocalData.readOnBoardingScreen();
                // EasyNavigation.push(
                //   context: context,
                //   page: const LoginScreen(),
                // );
              },
              child: Text(
                'skip',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  currentIndex = value;
                  setState(() {});
                },
                //scrollDirection: Axis.horizontal,
                itemCount: OnboardingLocalData.list.length,
                itemBuilder: (context, index) {
                  return OnboardingFrame(
                    onboardingModel: OnboardingLocalData.list[index],
                    pageController: pageController,
                    currentIndex: index,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 23),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                color:
                    currentIndex == OnboardingLocalData.list.length - 1
                        ? AppColors.primary
                        : AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: GestureDetector(
                onTap: () {
                  if (currentIndex == OnboardingLocalData.list.length - 1) {
                    OnboardingLocalData.readOnBoardingScreen();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserTypeScreen()),
                    );
                  } else {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  currentIndex == OnboardingLocalData.list.length - 1
                      ? 'Let’s Start'
                      : 'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        currentIndex == OnboardingLocalData.list.length - 1
                            ? AppColors.white
                            : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
