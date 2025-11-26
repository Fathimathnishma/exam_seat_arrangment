import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/student/students_login.dart';
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
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, state, child) {
          return  Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage(AppImages.Defaultprofile),
            ),
        
            SizedBox(height: 15),
        
            // STUDENT DETAILS FROM AUTH PROVIDER
            Text(
              "Name: ${student?.name ?? 'N/A'}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "Reg No: ${student?.regNo ?? 'N/A'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Department: ${student?.department ?? 'N/A'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Semester: ${student?.sem ?? 'N/A'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
        
            SizedBox(height: 35),
        
            // ---------------- MENU OPTIONS ----------------
            _menuTile(
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),));
              },
            ),
            SizedBox(height: 15),
        
            _menuTile(
              title: "Help",
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerServiceScreen(),));
              },
            ),
            SizedBox(height: 15),
        
            _menuTile(
              title: "delete",
              onTap: () {
                state.deleteStudentAccount();
              },
            ),
            SizedBox(height: 15),
        
            // LOGOUT
            InkWell(
              onTap: () async {
                await state.studentLogout();
                // CLEAR provider states before logout
               // context.read<AuthProvider>().l();
        
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentAuthScreen(),
                  ),
                );
              },
              child: _menuTile(
                title: "Log Out",
                color: Colors.red,
              ),
            ),
          ],
        );
        },
       
      ),
    );
  }

  Widget _menuTile({
    required String title,
    Color color = Colors.black,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color:  AppColors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.arrow_forward_ios, size: 18, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
