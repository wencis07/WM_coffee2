import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../atoms/quantity_selector.dart';
import '../atoms/cart_item_info.dart';

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
      color: const Color(0xFFF8F5F0),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE: Item info
            Expanded(
              child: CartItemInfo(
                name: name,
                unitPrice: unitPrice,
                totalPrice: totalPrice,
              ),
            ),

            // RIGHT SIDE: Quantity + Delete
            Column(
              children: [
                QuantitySelector(
                  quantity: quantity,
                  onIncrement: () async {
                    await cartRef.doc(id).update({
                      "quantity": FieldValue.increment(1),
                    });
                  },
                  onDecrement: () async {
                    if (quantity > 1) {
                      await cartRef.doc(id).update({
                        "quantity": FieldValue.increment(-1),
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await cartRef.doc(id).delete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}