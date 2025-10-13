import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: AppColors.primary, width: 1),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(color: AppColors.textColor, blurRadius: 1),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor),
            ),
          ),
        ),
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Gap(12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: ' Name ',
                  hintStyle: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                  suffixIcon: Icon(Icons.person_2_outlined),
                  enabledBorder: blueBorder,
                  focusedBorder: blueBorder,
                ),
                keyboardType: TextInputType.text, // ✅ Changed to text
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: blueBorder,
                  enabledBorder: blueBorder,
                  suffixIcon: Icon(Icons.email_outlined),
                  focusedBorder: blueBorder,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: AppColors.textColor),
                ),
              ),
              SizedBox(width: 10), // spacing between dropdowns
              TextFormField(
                decoration: InputDecoration(
                  border: blueBorder,
                  enabledBorder: blueBorder,
                  focusedBorder: blueBorder,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  hintText: 'Role',
                  suffixIcon: Icon(Icons.person_add_alt_rounded),
                  hintStyle: TextStyle(color: AppColors.textColor),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                height: 312,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      "Create New Role",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: ' User Name ',
                        hintStyle: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        suffixIcon: Icon(Icons.person_2_outlined),
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                      ),
                      keyboardType: TextInputType.text, // ✅ Changed to text
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        suffixIcon: Icon(Icons.email_outlined),
                        focusedBorder: blueBorder,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: AppColors.textColor),
                      ),
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
}
