import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('images/wmCoffee.png'),
      height: 200,
      width: 200,
    );
  }
}
