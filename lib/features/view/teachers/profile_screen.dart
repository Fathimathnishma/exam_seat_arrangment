import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
           
            Container(
              height: MediaQuery.sizeOf(context).height * 0.23,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

           
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.2 - 50,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(backgroundColor: AppColors.grey, radius: 80),
                  const SizedBox(height: 10),
                  const Text("User Name", style: TextStyle(fontSize: 20)),

                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildProfileOption("Profile"),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildProfileOption("Settings"),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildProfileOption("Notifications"),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildProfileOption("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
