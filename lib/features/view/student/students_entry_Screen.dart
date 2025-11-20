import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/student/student_dashbord.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:bca_exam_managment/features/view_model/exam_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsEntryScreen extends StatefulWidget {
  const StudentsEntryScreen({super.key});

  @override
  State<StudentsEntryScreen> createState() => _StudentsEntryScreenState();
}

class _StudentsEntryScreenState extends State<StudentsEntryScreen> {
  final TextEditingController registerNumberController =
      TextEditingController();
  String? selectedDepartment;
  String? sem;


  final OutlineInputBorder blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: Colors.blue, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
        final exam = Provider.of<ExamProvider>(context, listen: false);

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
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, state, Widget? child) { 
          return  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Student Dashboard",
                    style: TextStyle(
                      //  fontWeight: FontWeight.w900,
                      fontSize: 26,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                SizedBox(height: 44),
        
                // Register Number
                Text(
                  "Register Number:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: registerNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Register Number',
                    hintStyle: TextStyle(color: Color(0xFF8B8B8B), fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: blueBorder,
                    enabledBorder: blueBorder,
                    focusedBorder: blueBorder,
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 20),
        
                // Department
                Text(
                  'Select Your Department:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: blueBorder,
                    enabledBorder: blueBorder,
                    focusedBorder: blueBorder,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                  value: selectedDepartment,
                  hint: Text(
                    'Select',
                    style: TextStyle(color: Color(0xFF8B8B8B)),
                  ),
                  items:
                     exam. departments
                          .map(
                            (dept) =>
                                DropdownMenuItem(value: dept, child: Text(dept)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => selectedDepartment = val),
                ),
                 SizedBox(height: 20),
        
                // Department
                Text(
                  'Select Your sem:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: blueBorder,
                    enabledBorder: blueBorder,
                    focusedBorder: blueBorder,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                  value: sem,
                  hint: Text(
                    'Select',
                    style: TextStyle(color: Color(0xFF8B8B8B)),
                  ),
                  items:
                     exam.semesters
                          .map(
                            (dept) =>
                                DropdownMenuItem(value: dept, child: Text(dept)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => sem = val),
                ),
        
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'Please ensure your Register Number \n and Department are correct.',
                    //  style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                ), // replaces Spacer()
                // Button
                Center(
                  child: InkWell(
                    onTap: () async {
                      if (registerNumberController.text.isEmpty ||
                          selectedDepartment == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      } else {
                        await state.fetchSeatDetails(
                          regNo: registerNumberController.text, department:selectedDepartment! , sem:sem! );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(),
                        ),
                      );
                       }
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
        );
         },
       
      ),
    );
  }
}
