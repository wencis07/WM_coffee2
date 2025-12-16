import 'package:flutter/material.dart';

class AppTagline extends StatelessWidget {
  const AppTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'WM COFFEE',
          style: TextStyle(
            fontSize: 50,
            fontFamily: 'HOUTSNER_034557',
            color: Color.fromARGB(255, 60, 46, 4),
          ),
        ),

        Text(
          'Where Moments Brew Magic',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Color.fromARGB(255, 48, 37, 5),
          ),
        ),
      ],
    );
  }
}
