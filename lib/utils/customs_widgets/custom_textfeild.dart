import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final Widget suffixIcon; // Change the type to Widget
  final ValueChanged<String>? onChanged;

  CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon,
    this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Manage the password visibility here

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
    suffixIcon: GestureDetector(
    onTap: () {
    setState(() {
    _obscureText = !_obscureText;
    });
    },
    child: widget.suffixIcon,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
    color: Colors.grey[400]!,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
    color: Colors.grey[300]!,
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
    color: Colors.green, // Change this color to green
    ),
    ),
    ),);
  }
}




class PasswordVisibilityToggle extends StatefulWidget {
  final ValueNotifier<bool> obscureTextNotifier;

  PasswordVisibilityToggle({required this.obscureTextNotifier});

  @override
  _PasswordVisibilityToggleState createState() =>
      _PasswordVisibilityToggleState();
}

class _PasswordVisibilityToggleState extends State<PasswordVisibilityToggle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.obscureTextNotifier.value = !widget.obscureTextNotifier.value;
      },
      child: Icon(
        widget.obscureTextNotifier.value
            ? Icons.visibility
            : Icons.visibility_off_outlined,
      ),
    );
  }
}
