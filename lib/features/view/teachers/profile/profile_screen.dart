import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/profile_details.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings.dart';
import 'package:bca_exam_managment/features/view/teachers/teacher_login.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

Future<void> showLogoutDialog(BuildContext context, {required VoidCallback onConfirm,required String text}) async {
  return showDialog(
    context: context,  
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content:  Text('Are you sure you want to $text?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
             
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onConfirm(); // Run the logout logic
            },
            child:  Text(text),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, state, child) => 
       Scaffold(
        backgroundColor: AppColors.background,
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
                    CircleAvatar(backgroundColor: AppColors.grey, radius: 67),
                    const SizedBox(height: 10),
                     Text(state.currentUser?.name??"", style: TextStyle(fontSize: 20)),
      
                    const SizedBox(height: 22),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDetailsScreen(user: state.currentUser!,),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildProfileOption("Profile"),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
                        },
                        child: _buildProfileOption("Settings")),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap:() =>  showLogoutDialog(
        text: "Delete Account",
        onConfirm: () async {
          try {
            // Show a loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            await state.deleteAccount(
              userId: state.currentUser!.id!,
              onSuccess: () {
                Navigator.pop(context); // close loading
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => TeacherLoginScreen()),
                );
              },
            );
          } catch (e) {
            Navigator.pop(context); // close loading if error
            debugPrint('Error deleting account: $e');
          }
        },
        context,
      ),
    
                        child: _buildProfileOption("Delete Account")),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap:() =>  showLogoutDialog(
        text: "Logout",
        onConfirm: () async {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            await state.logout(
              onSuccess: () {
                Navigator.pop(context); // close loading
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => TeacherLoginScreen()),
                );
              },
            );
          } catch (e) {
            Navigator.pop(context); // close loading if error
            debugPrint('Error during logout: $e');
          }
        
                        },context
                        ),
                        child: _buildProfileOption("Logout")),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
