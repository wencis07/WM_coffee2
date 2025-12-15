import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
