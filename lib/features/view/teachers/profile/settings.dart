import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/about_app.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/customer_service_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/privacy&policy.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/settings/term&condition.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _shareApp() {
    // Share.share(
    //   'Check out this amazing app! Download now: https://play.google.com/store/apps/details?id=com.example.app',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',style: TextStyle(color: AppColors.textColor),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'About App',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutAppPage(),));
              },
            ),
            _buildSettingItem(
              icon: Icons.share_outlined,
              title: 'Share App',
              onTap: _shareApp,
            ),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>CustomerServiceScreen() ,));
              },
            ),
            const Divider(),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
             onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
  );
},

            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),));
              },
            ),
         
           
          ],
        ),
      ),
    );
  }



  // 🔹 Helper for each clickable item
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
