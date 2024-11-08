import 'package:flutter/material.dart';
import 'package:step/extensions/bottom_nav_item_builder.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.selectedIndex, required this.onTap, required this.currentDay});

  final int selectedIndex;
  final int currentDay;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        context.buildTodayBottomNavItem(
          isSelected: selectedIndex == 0,
          currentDay: currentDay
        ),
        context.buildUpcomingBottomNavItem(
            isSelected: selectedIndex == 1
        ),
        context.buildSearchBottomNavItem(
            isSelected: selectedIndex == 2
        ),
        context.buildBrowseBottomNavItem(
            isSelected: selectedIndex == 3
        ),
      ],
      currentIndex: selectedIndex, // Highlight selected item
      selectedItemColor: Colors.redAccent, // Color for the selected icon
      onTap: onTap // Update selected index when tapped
    );
  }
}
