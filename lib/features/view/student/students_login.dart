import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentAuthScreen extends StatefulWidget {
  const StudentAuthScreen({super.key});

  @override
  State<StudentAuthScreen> createState() => _StudentAuthScreenState();
}

class _StudentAuthScreenState extends State<StudentAuthScreen> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isSignIn = true; // Toggle between Sign In / Sign Up

  final OutlineInputBorder blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Consumer<AuthProvider>(
          builder: (context, state, child) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      isSignIn ? "Student Login" : "Student Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),

                  // Name
                  const Text("Name:", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),

                  // Student ID
                  const Text("Student ID:", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: studentIdController,
                    decoration: InputDecoration(
                      hintText: 'Enter your student ID or reg no',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  const Text("Password:", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final name = nameController.text.trim();
                        final studentId = studentIdController.text.trim();
                        final password = passwordController.text.trim();

                        if (name.isEmpty || studentId.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        if (isSignIn) {
                          await state.studentLogin(studentId:  studentId,password:  password);
                        } else {
                          await state.studentSignUp(studentId: studentId,password:  password, name: name);
                        }

                        if (!mounted) return;

                        if (state.currentUser != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AppRoot()),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          isSignIn ? 'Sign In' : 'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSignIn = !isSignIn; // Toggle mode
                        });
                      },
                      child: Text(
                        isSignIn
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Sign In",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
