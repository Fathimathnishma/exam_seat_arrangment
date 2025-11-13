import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/add_exam_sreens.dart';
import 'package:bca_exam_managment/features/view/teachers/exam/exam_screen%20.dart';
import 'package:bca_exam_managment/features/view/teachers/home_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/profile/profile_screen.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/add_rooms.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/all_room.dart';
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
    AllRoomScreens(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool showFab = _selectedIndex == 1 || _selectedIndex == 2;

    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              onPressed: () {
                if (_selectedIndex == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddExamScreens()),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddRoomsScreen()),
                  );
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // hide FAB completely
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomAppBar(
          shape: showFab ? const CircularNotchedRectangle() : null,
          color: AppColors.white,
          notchMargin: showFab ? 6 : 0,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                index: 0,
                activeIcon: AppImages.homeActive,
                inactiveIcon: AppImages.home,
              ),
              _navItem(
                index: 1,
                activeIcon: AppImages.examActive,
                inactiveIcon: AppImages.exam,
              ),

              // 🔹 Only show spacing when FAB is visible
              if (showFab) const SizedBox(width: 40),

              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: _selectedIndex == 2
                      ? AppColors.primary
                      : AppColors.black,
                ),
                onPressed: () => setState(() => _selectedIndex = 2),
              ),
              _navItem(
                index: 3,
                activeIcon: AppImages.profileActive,
                inactiveIcon: AppImages.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom widget for navigation icons (for cleaner code)
  Widget _navItem({
    required int index,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: SizedBox(
        height: 25,
        width: 25,
        child: Image.asset(
          _selectedIndex == index ? activeIcon : inactiveIcon,
        ),
      ),
    );
  }
}
