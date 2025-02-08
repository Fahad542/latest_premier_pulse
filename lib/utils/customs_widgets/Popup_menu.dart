import 'package:flutter/material.dart';

import '../../res/color.dart';

class MyPopupMenu extends StatelessWidget {
  final List<MenuItem> menuItems; // List of menu items to display
  final Function(String) onSelected; // Callback function for when a menu item is selected

  // Constructor to accept list of menu items and the onSelected callback
  MyPopupMenu({
    required this.menuItems,
    required this.onSelected, // Add onSelected as a required parameter
  });

  // Helper method to create a PopupMenuItem with text, icon, value, and onTap
  PopupMenuItem<String> _buildMenuItem({
    required String text,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem<String>(
      value: value, // Assigning the value parameter
      onTap: onTap, // Assigning the onTap callback for custom actions
      child: Row(
        children: [
          Container(
            height: 18,  // Icon container height
            width: 18,   // Icon container width
            decoration: BoxDecoration(
              color: AppColors.greencolor,  // Custom color for icon background
              borderRadius: BorderRadius.circular(6), // Rounded corners for the container
            ),
            child: Icon(icon, color: Colors.white, size: 14), // Custom icon with size and color
          ),
          SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12)), // Custom text style
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Call the onSelected callback passed from the parent widget
        onSelected(value);
        print('Selected: $value');
      },
      itemBuilder: (BuildContext context) {
        return menuItems.map((menuItem) {
          return _buildMenuItem(
            text: menuItem.text,
            icon: menuItem.icon,
            value: menuItem.value,
            onTap: menuItem.onTap,
          );
        }).toList();
      },
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  MenuItem({
    required this.text,
    required this.icon,
    required this.value,
    required this.onTap,
  });
}
