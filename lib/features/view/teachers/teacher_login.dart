import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

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
    borderSide: BorderSide(color: Colors.blue, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Teacher Authentication",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(height: 44),

              // Register Number
              Text(" Email id:", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 5),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Please Enter your Email id',
                  hintStyle: TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: blueBorder,
                  enabledBorder: blueBorder,
                  focusedBorder: blueBorder,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // Department
              Text('Password:', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 5),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Please Enter your Password:',
                  hintStyle: TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: blueBorder,
                  enabledBorder: blueBorder,
                  focusedBorder: blueBorder,
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 50),
              Center(
                child: Text(
                  'Please Enter your registered Email ID\n and your Secure Password',

                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.3,
              ), // replaces Spacer()
              // Button
              Center(
                child: InkWell(
                  onTap: () {
                    // if (registerNumberController.text.isEmpty ||
                    //     selectedDepartment == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Please fill all fields')),
                    //   );
                    // } else {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StudentDashboard(),
                    //   ),
                    // );
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
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
        ),
      ),
    );
  }
}
