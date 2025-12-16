import 'package:flutter/material.dart';

class CartItemInfo extends StatelessWidget {
  final String name;
  final int unitPrice;
  final int totalPrice;

  const CartItemInfo({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

       const SizedBox(height: 20),

        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Poppins-Light',
            fontSize: 20),
        ),

        const SizedBox(height: 10),
        
        Text(
          "₱$unitPrice",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        ),
      ],
    );
  }
}