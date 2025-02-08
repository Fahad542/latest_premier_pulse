import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final Function() onPress;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  RoundButton({
    required this.title,
    required this.loading,
    required this.onPress,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5, // Add elevation for the shadow effect
      borderRadius: BorderRadius.circular(borderRadius),
      child: ElevatedButton(
        onPressed: loading ? null : onPress,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: loading
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(title),
      ),
    );
  }
}
