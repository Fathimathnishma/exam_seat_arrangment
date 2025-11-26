import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Last updated: November 3, 2025',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),

              Text(
                '1. Introduction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'This Privacy Policy explains how we collect, use, and protect your personal information when you use our mobile application. '
                'By using this app, you agree to the terms outlined below.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '2. Information We Collect',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We may collect the following types of information:\n'
                '- Personal details (like name, email, or phone number)\n'
                '- Usage data (how you use the app)\n'
                '- Device information (model, OS version, etc.)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '3. How We Use Your Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'The collected data is used to:\n'
                '- Improve app performance and features\n'
                '- Provide customer support\n'
                '- Personalize your experience\n'
                '- Communicate important updates or offers',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '4. Data Security',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We implement appropriate security measures to protect your data. '
                'However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '5. Sharing of Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We do not sell or rent your personal data to third parties. '
                'We may share data only with trusted service providers who help us operate and improve the app, under strict confidentiality agreements.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '6. Your Rights',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'You have the right to access, update, or delete your personal data at any time. '
                'You can also withdraw your consent for data collection by contacting us.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '7. Changes to This Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We may update this Privacy Policy periodically. Any changes will be reflected here with an updated date.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '8. Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at:\n\n'
                '📧 Email: bcafinalyearproject2k24@gmail.com\n'
                '📞 Phone: +91 9876543210',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),

              Center(
                child: Text(
                  '© 2025 Your App Name. All rights reserved.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
