import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 100, color: Colors.brown),

          const SizedBox(height: 20),

          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: onLogout,
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
