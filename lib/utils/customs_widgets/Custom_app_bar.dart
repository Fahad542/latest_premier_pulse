import 'package:flutter/material.dart';

import '../../res/color.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  // Constructor to accept title and actions as parameters
  CustomAppBar({
    Key? key,
    required this.title,       // Title passed as a parameter
    this.actions = const [],  // Default to an empty list of actions if none are provided
  }) : preferredSize = Size.fromHeight(kToolbarHeight), // Standard AppBar height
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Color(0xFF1D2F4A), // Solid color background
      title: Center(  // Center the title
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 20,
          ),
        ),
      ),
      actions: actions,  // Pass custom actions here
    );
  }
}
