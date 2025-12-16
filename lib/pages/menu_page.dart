import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/atoms/section_title.dart';
import 'package:flutter_application_1/components/organisms/coffee_card.dart';

/// ===============================
/// MENU PAGE
/// ===============================
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  /// -------------------------------
  /// Convert Google Drive share link
  /// to direct-view image URL
  /// -------------------------------
  String convertDriveLink(String url) {
    final regex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      return 'https://drive.google.com/uc?export=view&id=${match.group(1)}';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    /// -------------------------------
    /// Get current logged-in user
    /// -------------------------------
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "Good Morning ☀️",
              subtitle: "It's time for a coffee break",
            ),

            const SizedBox(height: 50),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("coffees")
                    .orderBy("name")
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  // Empty state
                  if (docs.isEmpty) {
                    return const Center(child: Text("No coffees available"));
                  }

                  return GridView.builder(
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),

                    itemBuilder: (context, index) {
                      final coffee = Map<String, dynamic>.from(
                        docs[index].data() as Map<String, dynamic>,
                      );

                      String imageUrl = coffee['image']?.toString() ?? '';
                      if (imageUrl.contains('drive.google.com')) {
                        imageUrl = convertDriveLink(imageUrl);
                      }
                      coffee['image'] = imageUrl;

                      return CoffeeCard(
                        coffee: coffee,
                        onAdd: () async {
                          /// -------------------------------
                          /// Prevent adding if not logged in
                          /// -------------------------------
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please login first"),
                              ),
                            );
                            return;
                          }

                          final cartRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart');

                          /// -------------------------------
                          /// Check if coffee already exists
                          /// -------------------------------
                          final existingQuery = await cartRef
                              .where('name', isEqualTo: coffee['name'])
                              .limit(1)
                              .get();

                          if (existingQuery.docs.isNotEmpty) {
                            /// Update quantity
                            await existingQuery.docs.first.reference.update({
                              'quantity': FieldValue.increment(1),
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                          } else {
                            /// Add new item
                            await cartRef.add({
                              'name': coffee['name'],
                              'price': coffee['price'],
                              'image': coffee['image'],
                              'quantity': 1,
                              'addedAt': FieldValue.serverTimestamp(),
                            });
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("${coffee['name']} added to cart"),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
