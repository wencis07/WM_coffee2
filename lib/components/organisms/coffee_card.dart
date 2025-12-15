import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final Map<String, dynamic> coffee;
  final VoidCallback onAdd;

  const CoffeeCard({
    super.key,
    required this.coffee,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              coffee["image"],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            coffee["name"],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 4),

          Text("₱${coffee["price"]}",
              style: const TextStyle(color: Colors.orange)),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
