import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  // Function to open external links
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/app-logo.png", // Your app logo
                    height: 100,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'EduSeat',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About the App
            const Text(
              'About the App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Exam-Friend is an exam management application designed to help teachers and '
              'administrators organize exams efficiently. The app allows users to add rooms, '
              'sort students, and prepare structured exam schedules with ease. It ensures smooth '
              'coordination between exam halls, students, and invigilators for a stress-free exam process.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Developer Info
            const Text(
              'Developer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Developed by softroniics Team\nFlutter Developer at Softronics',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Contact Section
            const Text(
              'Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('support@examfriend.com'),
              onTap: () => _launchUrl('mailto:support@examfriend.com'),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('www.examfriend.com'),
              onTap: () => _launchUrl('https://www.examfriend.com'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () => _launchUrl('https://www.examfriend.com/privacy'),
            ),
            const SizedBox(height: 20),

            // Footer
            const Center(
              child: Text(
                '© 2025 Exam-Friend\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
