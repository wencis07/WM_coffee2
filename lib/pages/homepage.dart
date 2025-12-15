import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/atoms/section_title.dart';
import 'package:flutter_application_1/components/molecules/cart_item_tile.dart';
import 'package:flutter_application_1/components/organisms/coffee_card.dart';
import 'package:flutter_application_1/components/organisms/profile_info.dart';
import 'package:flutter_application_1/main.dart';

List<Map<String, dynamic>> cartItems = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    MenuPage(),
    CartPage(),
    ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// MENU PAGE
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  /// Converts Google Drive share links to direct image links
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
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("coffees").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Center(child: Text("No coffees available"));

                  return GridView.builder(
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final coffee = Map<String, dynamic>.from(docs[index].data() as Map<String, dynamic>);
                      
                      // Convert Google Drive link
                      String imageUrl = coffee["image"]?.toString() ?? "";
                      if (imageUrl.contains("drive.google.com")) {
                        imageUrl = convertDriveLink(imageUrl);
                      }
                      coffee["image"] = imageUrl;

                      return CoffeeCard(
                        coffee: coffee,
                        onAdd: () async {
                          if (user == null) return;

                          final coffeeData = {
                            "name": coffee["name"],
                            "price": coffee["price"],
                            "quantity": 1,
                            "addedAt": FieldValue.serverTimestamp(),
                          };

                          try {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.uid)
                                .collection("cart")
                                .add(coffeeData);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${coffee["name"]} added to cart")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to add to cart: $e")),
                            );
                          }
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


// CART PAGE
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  int calculateTotal(List<Map<String, dynamic>> items) {
    int total = 0;
    for (var item in items) {
      total += item["price"] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text("Please log in"));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "My Cart"),
            const SizedBox(height: 20),
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("cart")
                    .orderBy("addedAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final cartDocs = snapshot.data!.docs;
                  final cartItems = cartDocs
                      .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
                      .toList();

                  if (cartItems.isEmpty) {
                    return const Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 16)));
                  }

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemTile(
                        item: item,
                        onDelete: () async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.uid)
                              .collection("cart")
                              .doc(item["id"])
                              .delete();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .collection("cart")
                  .snapshots(),
              builder: (context, snapshot) {
                final cartDocs = snapshot.data?.docs ?? [];
                final cartItems = cartDocs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                final totalPrice = calculateTotal(cartItems);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "₱$totalPrice",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 218, 158, 69),
                  padding: const EdgeInsets.all(25),
                ),
                onPressed: () async {
                  final cartSnapshot = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .collection("cart")
                      .get();

                  if (cartSnapshot.docs.isEmpty) return;

                  final cartItems = cartSnapshot.docs
                      .map((doc) => doc.data())
                      .toList();

                  final totalPrice = calculateTotal(
                      cartItems.map((e) => e).toList());

                  try {
                    // 1️⃣ Add to 'checkouts' collection
                    await FirebaseFirestore.instance.collection("checkouts").add({
                      "userId": user.uid,
                      "totalPrice": totalPrice,
                      "items": cartItems,
                      "createdAt": FieldValue.serverTimestamp(),
                    });

                    // 2️⃣ Clear the cart
                    for (var doc in cartSnapshot.docs) {
                      await doc.reference.delete();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order Successful ✅")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Checkout failed: $e")),
                    );
                  }
                },
                child: const Text(
                  "Checkout",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// PROFILE PAGE

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData =
              snapshot.data!.data() as Map<String, dynamic>;

          return ProfileInfo(
            name: userData["name"],
            email: userData["email"],
            onLogout: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
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
