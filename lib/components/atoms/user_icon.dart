import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final double size;
  final Color color;

  const UserIcon({super.key, this.size = 100, this.color = Colors.brown});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person, size: size, color: color);
  }
}
