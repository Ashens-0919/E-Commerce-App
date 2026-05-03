import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Controller/AuthController.dart';
import '../Provider/OrdersProvider.dart';
import 'LoginPage.dart';
import 'MyOrdersPage.dart';
import 'ShippingAddressPage.dart';
import 'PurchaseHistoryPage.dart';
import 'RatingPage.dart';
import 'WishlistPage.dart';
import 'InviteFriendsPage.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final orders = ref.watch(ordersProvider);
    final isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Account", 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2), 
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.settings_outlined, color: Colors.white),
                  )
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      // Profile Card
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isLoggedIn ? (user.name ?? "Verified User") : "Guest User", 
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(isLoggedIn ? (user.contact ?? "No Phone") : "Login to save your progress",
                                style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // My Purchases Section
                      Column(
                        children: [
                          _sectionHeader(context, "My Purchases", "View History", () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()));
                          }),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _orderStatusIcon(context, Icons.payment, "To Pay", 
                                orders.where((o) => o.status == "To Pay").length),
                              _orderStatusIcon(context, Icons.inventory_2_outlined, "To Ship", 
                                orders.where((o) => o.status == "To Ship" || o.status == "Processing").length),
                              _orderStatusIcon(context, Icons.local_shipping_outlined, "To Receive", 
                                orders.where((o) => o.status == "To Receive").length),
                              _orderStatusIcon(context, Icons.star_outline, "To Rate", 
                                orders.where((o) => o.status == "Completed").expand((o) => o.items).length),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 35),
                      const Divider(),

                      // Features List
                      _profileListTile(context, Icons.location_on_outlined, "My Addresses", () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressPage()));
                      }),
                      _profileListTile(context, Icons.favorite_border, "My Wishlist", () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistPage()));
                      }),
                      _profileListTile(context, Icons.person_add_alt, "Invite Friends", () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const InviteFriendsPage()));
                      }),

                      const SizedBox(height: 30),

                      // Logout Button
                      if (isLoggedIn)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(authControllerProvider.notifier).logout();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text("LOGOUT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text("LOGIN / SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, String actionText, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(actionText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _orderStatusIcon(BuildContext context, IconData icon, String label, int count) {
    return GestureDetector(
      onTap: () {
        if (label == "To Rate") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RatingPage()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()));
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              Icon(icon, color: Colors.orange[800], size: 28),
              if (count > 0)
                Positioned(
                  right: 0, top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                )
            ],
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _profileListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
