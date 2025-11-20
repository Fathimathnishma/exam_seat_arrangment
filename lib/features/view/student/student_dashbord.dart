import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bca_exam_managment/core/utils/app_colors.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final seatInfo = provider.seatDetails; // Map<String, dynamic>?

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
          ? Center(child: CircularProgressIndicator())
          : seatInfo == null
              ? Center(
                  child: Text(
                    "No Seat Details Found",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoBox("Your Name: ${seatInfo['name']}"),
                      SizedBox(height: 15),

                      _infoBox("Your Register Number: ${seatInfo['regNo']}"),
                      SizedBox(height: 15),

                      _infoBox("Your Department: ${seatInfo['department']}"),
                      SizedBox(height: 15),

                      _infoBox("Your Room Number: ${seatInfo['roomNo']}"),
                      SizedBox(height: 15),

                      _infoBox("Your Seat Number: ${seatInfo['seatNo']}"),
                      SizedBox(height: 40),

                      Text(
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

  // UI Box Component
  Widget _infoBox(String text) {
    return Container(
      padding: EdgeInsets.all(12),
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
