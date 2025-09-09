import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/teachers/profile_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/add_exam_sreens.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/all_room.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/exam_screen%20.dart';
import 'package:bca_exam_managment/features/view/teachers/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AllExamScreen(),
    AddExamScreens(), // Center (Cart) Page
    AllRoomScreens(), // Search (change as needed)
    ProfileScreen(), // Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 75,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', 0),
                _buildNavItem(Icons.favorite_border, 'exams', 1),
                const SizedBox(width: 48), // Spacer for center FAB
                _buildNavItem(Icons.search, 'rooms', 3),
                _buildNavItem(Icons.settings, 'profile', 4),
              ],
            ),
          ),

          Positioned(
            bottom: 18,
            child: SizedBox(
              height: 49,
              width: 49,
              child: FloatingActionButton(
                onPressed: () => _onItemTapped(2),
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                elevation: 6,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.primary : Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          // Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 11,
          //     fontWeight: FontWeight.w600,
          //     color: isSelected ? AppColors.primary: Colors.grey.shade600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
