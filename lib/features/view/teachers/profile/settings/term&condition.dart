import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms & Conditions',
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
                '1. Acceptance of Terms',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'By using this application, you agree to comply with and be bound by these Terms and Conditions. '
                'If you do not agree with any part of these terms, please do not use the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '2. Use of the App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'You agree to use this app only for lawful purposes and in a way that does not infringe on the rights of others. '
                'Unauthorized use, distribution, or modification of app content is strictly prohibited.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '3. User Accounts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'You may be required to create an account to access certain features. '
                'You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '4. Intellectual Property',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'All content, design, and materials within this app are the property of the developer or licensors. '
                'You may not reproduce, distribute, or create derivative works without prior permission.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '5. Limitation of Liability',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We are not responsible for any direct, indirect, or consequential damages resulting from your use or inability to use the app. '
                'The app is provided "as is" without warranties of any kind.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '6. Termination of Use',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We reserve the right to suspend or terminate your access to the app at any time without prior notice, '
                'if we believe you have violated these terms.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '7. Changes to the Terms',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'We may update these Terms and Conditions at any time. '
                'Any changes will be posted within the app, and continued use of the app means you accept the updated terms.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '8. Governing Law',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'These Terms are governed by and interpreted in accordance with the laws of India. '
                'Any disputes will be subject to the exclusive jurisdiction of the courts in your region.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                '9. Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'If you have any questions or concerns about these Terms & Conditions, please contact us at:\n\n'
                '📧 Email: support@example.com\n'
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
