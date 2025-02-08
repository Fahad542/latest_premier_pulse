import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomGradientContainer extends StatelessWidget {
  final String text;
  final double value;
  final Color gradientStartColor;
  final Color gradientEndColor;

  CustomGradientContainer({
    required this.text,
    required this.value,
    required this.gradientStartColor,
    required this.gradientEndColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust the padding based on the screen width
    double paddingValue = screenWidth * 0.02; // You can adjust this percentage based on your preference

    return Container(
      padding: EdgeInsets.all(paddingValue),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(paddingValue * 2), // Adjust the multiplier as needed
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStartColor, gradientEndColor],
        ),
        boxShadow: [
          BoxShadow(
            color: gradientStartColor,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$text: $value%',
          style: TextStyle(color: Colors.white, fontSize: paddingValue * 1.4, fontWeight: FontWeight.w500), // Adjust the multiplier as needed
        ),
      ),
    );
  }
}
