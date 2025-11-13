import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final OutlineInputBorder blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Consumer<AuthProvider>(
          builder: (context, state, child) {
            // ✅ If loading, show progress indicator
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Teacher Authentication",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),

                  // Email Field
                  const Text("Email ID:", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Please enter your email ID',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  const Text('Password:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Please enter your password',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                  ),

                  const SizedBox(height: 50),
                  const Center(
                    child: Text(
                      'Please enter your registered Email ID\nand your secure Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),

                  // Submit Button
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        await state.login(email, password);

                        if (!mounted) return; // ✅ Prevent context error

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
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
