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
      body: Stack(
        children: [
          // Background top container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          // Foreground content
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(backgroundColor: AppColors.yellow, radius: 80),
                const SizedBox(height: 10),
                const Text("User Name", style: TextStyle(fontSize: 20)),

                const SizedBox(height: 22),
                _buildProfileOption("Profile"),
                const SizedBox(height: 22),
                _buildProfileOption("Settings"),
                const SizedBox(height: 22),
                _buildProfileOption("Notifications"),
                const SizedBox(height: 22),
                _buildProfileOption("Logout"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title) {
    return Container(
      height: 70,
      width: double.infinity, // works now since parent has constraints
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
