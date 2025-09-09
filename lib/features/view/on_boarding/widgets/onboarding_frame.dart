import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/onbording/onbording_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingFrame extends StatelessWidget {
  OnboardingFrame({
    super.key,
    required this.onboardingModel,
    required this.pageController,
    required this.currentIndex,
  });
  final OnboardingModel onboardingModel;
  final PageController pageController;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.asset(onboardingModel.image, fit: BoxFit.contain),
          ),
          const Gap(20),
          SmoothPageIndicator(
            controller: pageController,
            count: OnboardingLocalData.list.length,
            effect: ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              spacing: 5,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.primary.withOpacity(0.2),
              paintStyle: PaintingStyle.fill,
            ),
          ),
          const Gap(40),
          Text(
            onboardingModel.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
              color: AppColors.textColor,
              //     .white, // Color here doesn't matter due to the gradient.
            ),
          ),
          const Gap(8),
          Text(
            onboardingModel.description,
            style: TextStyle(
              // maxLines: 3,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
          Gap(30),
        ],
      ),
    );
  }
}
