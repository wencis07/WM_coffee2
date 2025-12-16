import 'package:flutter/material.dart';
import '../atoms/user_icon.dart';

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
          const UserIcon(),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            email,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16, 
              color: Colors.grey),
          ),

          const SizedBox(height: 20),

          // Keep exact ElevatedButton design for logout
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onLogout,
            child: const Text(
              "Logout",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
