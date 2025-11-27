import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/student/students_profile.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final seatInfo = provider.seatDetails;

    /// Safely access student information
    final studentInfo = seatInfo?["seatData"]?["student"];

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

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())

          // ---- CASE 1: No Seat Data Found ----
          : seatInfo == null
              ? Center(
                  child: Text(
                    "No Seat Details Found",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                )

              // ---- CASE 2: Seat Exists but NOT Allowed to Show ----
              : seatInfo["allowed"] == false
                  ? Center(
                      child: Text(
                        seatInfo["message"] ?? "Seat cannot be shown now",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )

                  // ---- CASE 3: Missing Student Data ----
                  : studentInfo == null
                      ? const Center(
                          child: Text(
                            "Student data missing in seat record",
                            style: TextStyle(color: Colors.red),
                          ),
                        )

                      // ---- CASE 4: SUCCESS → SHOW SEAT DETAILS ----
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoBox("Your Name: ${studentInfo['name']}"),
                              const SizedBox(height: 15),

                              _infoBox(
                                  "Your Register Number: ${studentInfo['regNo']}"),
                              const SizedBox(height: 15),

                              _infoBox(
                                  "Your Department: ${studentInfo['department']}"),
                              const SizedBox(height: 15),

                              _infoBox("Your Room Code: ${seatInfo['roomCode'] ?? 'N/A'}"),
                              const SizedBox(height: 15),

                              _infoBox("Your Room Name: ${seatInfo['roomName'] ?? 'N/A'}"),
                              const SizedBox(height: 15),

                              _infoBox("Your Seat Number: ${seatInfo['seatData']?['seatNo'] ?? 'N/A'}"),
                              const SizedBox(height: 40),

                              const Text(
                                "Please ensure all details (Name, Register Number, Department, Room Number, Seat Number) are correct.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
