import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/atoms/section_title.dart';
import 'package:flutter_application_1/components/organisms/cart_item_tile.dart';

/// ===============================
/// CART PAGE
/// ===============================
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  /// -------------------------------
  /// Calculate total cart price
  /// -------------------------------
  int calculateTotal(List<Map<String, dynamic>> items) {
    int total = 0;
    for (var item in items) {
      final price = (item['price'] ?? 0) as int;
      final quantity = (item['quantity'] ?? 1) as int;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    /// -------------------------------
    /// Get current user
    /// -------------------------------
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in'));
    }
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------------------------------
            /// Page Title
            /// -------------------------------
            const SectionTitle(title: 'My Cart'),

            const SizedBox(height: 20),

            /// -------------------------------
            /// Cart Items List
            /// -------------------------------
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: cartRef
                    .orderBy('addedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load cart'));
                  }

                  final cartDocs = snapshot.data?.docs ?? [];

                  // Empty cart
                  if (cartDocs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  final cartItems = cartDocs
                      .map((doc) => {
                            'id': doc.id,
                            ...doc.data() as Map<String, dynamic>,
                          })
                      .toList();

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: CartItemTile(
                          item: item,
                          cartRef: cartRef,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// -------------------------------
            /// GRAND TOTAL
            /// -------------------------------
            StreamBuilder<QuerySnapshot>(
              stream: cartRef.snapshots(),
              builder: (context, snapshot) {
                final cartDocs = snapshot.data?.docs ?? [];
                final cartItems = cartDocs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                final totalPrice = calculateTotal(cartItems);

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade700,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '₱$totalPrice',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            /// -------------------------------
            /// CHECKOUT BUTTON
            /// -------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final cartSnapshot = await cartRef.get();

                  if (cartSnapshot.docs.isEmpty) return;

                  final cartItems = cartSnapshot.docs
                      .map((doc) => doc.data())
                      .toList();

                  final totalPrice = calculateTotal(cartItems);

                  try {
                    /// Create checkout record
                    await FirebaseFirestore.instance
                        .collection('checkouts')
                        .add({
                      'userId': user.uid,
                      'totalPrice': totalPrice,
                      'items': cartItems,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    /// Clear cart
                    for (var doc in cartSnapshot.docs) {
                      await doc.reference.delete();
                    }

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order Successful ✅'),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checkout failed: $e')),
                    );
                  }
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
