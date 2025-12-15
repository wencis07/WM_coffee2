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
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 50),
        Text(
          "₱$unitPrice",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
