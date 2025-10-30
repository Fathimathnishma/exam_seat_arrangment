import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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

  TextEditingController newUsername = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newRole = TextEditingController();
  TextEditingController profileName = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profileRole = TextEditingController();




  bool _isCreateUserVisible = false; // 👈 Toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
        title: const Center(child: Text("Profile")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Consumer<AuthProvider>(
            builder:(context, state, child) {
              return  Column(
              children: [
                /// Profile details
                Column(
                  children: [
                    TextFormField(
                      controller: profileName,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: blueBorder,
                        suffixIcon: const Icon(Icons.person_2_outlined),
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: profileEmail,
                      decoration: InputDecoration(
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        suffixIcon: const Icon(Icons.email_outlined),
                        focusedBorder: blueBorder,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: AppColors.textColor),
                      ),
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: profileRole,
                      decoration: InputDecoration(
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        hintText: 'Role',
                        suffixIcon: const Icon(Icons.person_add_alt_rounded),
                        hintStyle: TextStyle(color: AppColors.textColor),
                      ),
                    ),
                  ],
                ),
                const Gap(25),
            
                /// Toggle header row
                InkWell(
                  onTap: () {
                    setState(() {
                      _isCreateUserVisible = !_isCreateUserVisible;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary.withOpacity(0.1),
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create New User",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          _isCreateUserVisible
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
            
                /// Expandable form
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isCreateUserVisible
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: newUsername,
                                    decoration: InputDecoration(
                                      hintText: 'User Name',
                                      hintStyle: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                      border: blueBorder,
                                      suffixIcon:
                                          const Icon(Icons.person_2_outlined),
                                      enabledBorder: blueBorder,
                                      focusedBorder: blueBorder,
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextFormField(
                                    controller: newEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                      border: blueBorder,
                                      suffixIcon:
                                          const Icon(Icons.email_outlined),
                                      enabledBorder: blueBorder,
                                      focusedBorder: blueBorder,
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextFormField(
                                    controller: newRole,
                                    decoration: InputDecoration(
                                      hintText: 'Role',
                                      hintStyle: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                      border: blueBorder,
                                      suffixIcon:
                                          const Icon(Icons.person_add_alt_1),
                                      enabledBorder: blueBorder,
                                      focusedBorder: blueBorder,
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextFormField(
                                    controller: newPassword,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                      border: blueBorder,
                                      suffixIcon:
                                          const Icon(Icons.lock_outline),
                                      enabledBorder: blueBorder,
                                      focusedBorder: blueBorder,
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                  const Gap(20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 60,
                                      ),
                                    ),
                                    onPressed: () {
                                     state.register(
                                      UserModel(
                                        email: newEmail.text, 
                                        password: newPassword.text, 
                                        role: newRole.text));
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );  
            } ,
            
          ),
        ),
      ),
    );
  }
}
