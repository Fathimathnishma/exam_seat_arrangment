import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/user_type_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/customer_service_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/privacy&policy.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stdprofile extends StatefulWidget {
  const Stdprofile({super.key});

  @override
  State<Stdprofile> createState() => _StdProfileState();
}

class _StdProfileState extends State<Stdprofile> {
  @override
  Widget build(BuildContext context) {
    final student = context.watch<AuthProvider>().currentStudentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      body: Consumer<AuthProvider>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // PROFILE IMAGE
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage(AppImages.Defaultprofile),
                ),

                const SizedBox(height: 10),

                // STUDENT DETAILS
                Text(
                  "Name: ${student?.name ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Reg No: ${student?.regNo ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Department: ${student?.department ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Semester: ${student?.sem ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // MENU TILES
                _menuTile(
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _menuTile(
                  title: "Help",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerServiceScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // DELETE ACCOUNT
                _menuTile(
                  title: "Delete Account",
                  color: Colors.red,
                  onTap: () {
                    showLogoutDialog(
                      context,
                      text: "Delete Account",
                      onConfirm: () async {
                        final deleted = await state.deleteStudentAccount();

                        if (deleted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => UserTypeScreen()),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),

                // LOGOUT
                _menuTile(
                  title: "Log Out",
                  color: Colors.red,
                  onTap: () {
                    showLogoutDialog(
                      context,
                      text: "Logout",
                      onConfirm: () async {
                        await state.studentLogout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => UserTypeScreen()),
                          (_) => false,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // REUSABLE TILE
  Widget _menuTile({
    required String title,
    Color color = Colors.black,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

// CONFIRMATION DIALOG
Future<void> showLogoutDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  required String text,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to $text?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(text),
          ),
        ],
      );
    },
  );
}
