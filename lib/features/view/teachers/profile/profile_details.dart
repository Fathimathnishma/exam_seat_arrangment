import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/user_model.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/users_show_screen.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final UserModel user;
  const ProfileDetailsScreen({super.key, required this.user});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: AppColors.primary, width: 1),
  );
  final _formKey = GlobalKey<FormState>();

  TextEditingController newUsername = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController profileRole = TextEditingController();

  bool _isCreateUserVisible = false; // Toggle state

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
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
        title: const Center(child: Text("Profile")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Consumer<AuthProvider>(
            builder: (context, state, child) {
              final isAdmin = state.currentUser?.role == 'Admin';

              return Column(
                children: [
                  // 🔹 Profile details (now just display text containers)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoContainer(
                        icon: Icons.person_2_outlined,
                        label: 'Name',
                        value: widget.user.name ?? 'N/A',
                      ),
                      const SizedBox(height: 10),
                      _infoContainer(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: widget.user.email ?? 'N/A',
                      ),
                      const SizedBox(height: 10),
                      _infoContainer(
                        icon: Icons.person_add_alt_rounded,
                        label: 'Role',
                        value: widget.user.role ?? 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 🔹 ONLY ADMIN: Show Create New User section

                  
                  if (isAdmin)
                    Column(
                      children: [
                         InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsersScreen(),));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primary.withOpacity(0.1),
                              border: Border.all(color: AppColors.primary, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "View all Users",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isCreateUserVisible = !_isCreateUserVisible;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            // USERNAME FIELD
                                            TextFormField(
                                              controller: newUsername,
                                              decoration: InputDecoration(
                                                hintText: 'User Name',
                                                hintStyle: TextStyle(
                                                    color: AppColors.textColor, fontSize: 14),
                                                border: blueBorder,
                                                suffixIcon: const Icon(Icons.person_2_outlined),
                                                enabledBorder: blueBorder,
                                                focusedBorder: blueBorder,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 12),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.trim().isEmpty) {
                                                  return 'Username is required';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),

                                            // EMAIL FIELD
                                            TextFormField(
                                              controller: newEmail,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                hintStyle: TextStyle(
                                                    color: AppColors.textColor, fontSize: 14),
                                                border: blueBorder,
                                                suffixIcon: const Icon(Icons.email_outlined),
                                                enabledBorder: blueBorder,
                                                focusedBorder: blueBorder,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 12),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.trim().isEmpty) {
                                                  return 'Email is required';
                                                }
                                                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                                if (!emailRegex.hasMatch(value)) {
                                                  return 'Enter a valid email';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),

                                            // ROLE DROPDOWN
                                            DropdownButtonFormField<String>(
                                              value: profileRole.text.isNotEmpty
                                                  ? profileRole.text
                                                  : null,
                                              decoration: InputDecoration(
                                                border: blueBorder,
                                                enabledBorder: blueBorder,
                                                focusedBorder: blueBorder,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 12),
                                                hintText: 'Role',
                                                hintStyle: TextStyle(color: AppColors.textColor),
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Admin',
                                                  child: Text('Admin'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Teacher',
                                                  child: Text('Teacher'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  profileRole.text = value;
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select a role';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),

                                            // PASSWORD FIELD
                                            TextFormField(
                                              controller: newPassword,
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                hintStyle: TextStyle(
                                                    color: AppColors.textColor, fontSize: 14),
                                                border: blueBorder,
                                                suffixIcon: const Icon(Icons.lock_outline),
                                                enabledBorder: blueBorder,
                                                focusedBorder: blueBorder,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 12),
                                              ),
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == null || value.trim().isEmpty) {
                                                  return 'Password is required';
                                                }
                                                if (value.length < 6) {
                                                  return 'Password must be at least 6 characters';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),

                                            // SAVE BUTTON
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 14, horizontal: 60),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  await state.addUserByAdmin(
                                                    UserModel(
                                                      email: newEmail.text,
                                                      name: newUsername.text,
                                                      password: newPassword.text,
                                                      role: profileRole.text,
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔹 Custom info container widget (non-editable display)
  Widget _infoContainer({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
