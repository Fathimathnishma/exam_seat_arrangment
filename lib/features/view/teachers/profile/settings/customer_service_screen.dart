// ignore_for_file: use_build_context_synchronously

import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';



class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});
  

  @override
  
  Widget build(BuildContext context) {
    final Uri _phone = Uri.parse("tel:+919876543210");
    final Uri _email = Uri(
    scheme: 'mailto',
    path: 'example@email.com',
    query: 'subject=Greetings&body=Hello, this is from Flutter app',
  );
  final Uri _whatsapp = Uri.parse("https://wa.me/919876543210?text=Hello%20Support");

  Future<void> _launch(Uri url) async {
    if (!await launchUrl    (url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              
              title: Text(
                'Customer Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _customerSupportItemsFrame(
                        AppImages.whatsapp, 'Chat With WhatsApp', () {
                  //   log('worikgin');
                      _launch(_whatsapp);
                                          }),
                    const Gap(10),
                    _customerSupportItemsFrame(
                        AppImages.email, 'Open With E-Mail', () {
                      _launch(_email);
                    }),
                    const Gap(10),
                    _customerSupportItemsFrame(
                        AppImages.phone, 'Call Our Executive', () {
                     _launch(_phone);
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _customerSupportItemsFrame(
    String image, String iteam, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(86),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 20,
          ),
          const Gap(7),
          Text(
            iteam,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          )
        ],
      ),
    ),
  );
}
