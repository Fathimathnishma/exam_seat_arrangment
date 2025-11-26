import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/app_root/app_root.dart';
import 'package:bca_exam_managment/features/view/student/student_dashbord.dart';
import 'package:bca_exam_managment/features/view/student/students_entry_Screen.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? department;
  String? sem;
  bool isSignIn = true;

  final OutlineInputBorder blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
  );

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exam = Provider.of<ExamProvider>(context, listen: false);

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

                  // Name (Sign Up only)
                  if (!isSignIn) ...[
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
                  ],

                  // Student ID
                  const Text("Student ID:", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
              TextFormField(
  controller: studentIdController,

  // ⭐ This makes the keyboard show CAPITAL letters
  textCapitalization: TextCapitalization.characters,

  decoration: InputDecoration(
    hintText: 'Enter your student ID or reg no',
    hintStyle: TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  const SizedBox(height: 14),

                  // Department (Signup)
                  if (!isSignIn) ...[
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      value: department,
                      hint: const Text("Department"),
                      items: exam.departments
                          .map(
                            (dept) => DropdownMenuItem(
                              value: dept,
                              child: Text(dept),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          department = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Semester
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      value: sem,
                      hint: const Text("Semester"),
                      items: exam.semesters
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          sem = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Button
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final studentId = studentIdController.text.trim();
                        final password = passwordController.text.trim();
                        final name = nameController.text.trim();

                        // Basic Validation
                        if (studentId.isEmpty || password.isEmpty) {
                          showError("Please fill all required fields");
                          return;
                        }

                        // SignUp validation
                        if (!isSignIn && (name.isEmpty || department == null || sem == null)) {
                          showError("Please fill all fields");
                          return;
                        }

                        // 🔥 LOGIN or SIGNUP
                        if (isSignIn) {
                          await state.studentLogin(
                            studentId: studentId,
                            password: password,
                          );
                        } else {
                          await state.studentSignUp(
                            studentId: studentId,
                            password: password,
                            name: name,
                            department: department!,
                            sem: sem!,
                          );
                        }

                        if (!mounted) return;

                        // SUCCESS redirect
                        if (state.currentStudentUser != null) {
                          // CLEAR FIELDS 🎉
                          studentIdController.clear();
                          nameController.clear();
                          passwordController.clear();
                          setState(() {
                            department = null;
                            sem = null;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => StudentsEntryScreen()),
                          );
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
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

                  // Toggle Login / Signup
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSignIn = !isSignIn;
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
