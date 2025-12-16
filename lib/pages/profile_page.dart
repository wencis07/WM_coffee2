import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/organisms/profile_info.dart';
import 'package:flutter_application_1/main.dart';

/// ===============================
/// PROFILE PAGE
/// ===============================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// -------------------------------
    /// Get current logged-in user
    /// -------------------------------
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      /// -------------------------------
      /// StreamBuilder for user data
      /// -------------------------------
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          /// -------------------------------
          /// User data extraction
          /// -------------------------------
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          /// -------------------------------
          /// ProfileInfo Widget
          /// -------------------------------
          return ProfileInfo(
            name: userData["username"],
            email: userData["email"],
            onLogout: () async {
              /// Logout user
              await FirebaseAuth.instance.signOut();

              /// Navigate to LandingPage
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandingPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}