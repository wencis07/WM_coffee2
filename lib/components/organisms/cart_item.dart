import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final CollectionReference cartRef;

  const CartItemTile({
    super.key,
    required this.item,
    required this.cartRef,
  });

  @override
  Widget build(BuildContext context) {
    final String id = item["id"];
    final String name = item["name"];
    final int unitPrice = item["price"];
    final int quantity = item["quantity"];
    final int totalPrice = unitPrice * quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // NAME + QUANTITY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee name and quantity buttons in same row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Quantity buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () async {
                                if (quantity > 1) {
                                  await cartRef.doc(id).update({
                                    "quantity": FieldValue.increment(-1),
                                  });
                                }
                              },
                            ),
                            Text(
                              "$quantity",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () async {
                                await cartRef.doc(id).update({
                                  "quantity": FieldValue.increment(1),
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Total price
                  Text(
                    "₱$unitPrice x $quantity = ₱$totalPrice",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // DELETE BUTTON
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                await cartRef.doc(id).delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
