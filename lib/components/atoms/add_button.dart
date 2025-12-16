import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed, required bool isLoading});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.add, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.brown,
      ),
    );
  }
}
