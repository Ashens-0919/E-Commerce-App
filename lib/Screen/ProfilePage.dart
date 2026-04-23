import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_controller.dart';
import 'LoginPage.dart';
import 'MyOrdersPage.dart';
import 'ShippingAddressPage.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Profile Header
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(isLoggedIn ? Icons.person : Icons.person_outline, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  isLoggedIn ? user.name : "Guest User",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  isLoggedIn ? user.contact : "Please login to see your data",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // Content Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      _profileOption(context, Icons.shopping_bag_outlined, "My Orders", isLoggedIn),
                      _profileOption(context, Icons.location_on_outlined, "Shipping Address", isLoggedIn),
                      _profileOption(context, Icons.payment_outlined, "Payment Methods", isLoggedIn),
                      const Divider(height: 30, indent: 20, endIndent: 20),
                      _profileOption(context, Icons.settings_outlined, "Settings", true),
                      _profileOption(context, Icons.help_outline, "Help Center", true),
                      
                      const SizedBox(height: 30),
                      
                      // Login/Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (isLoggedIn) {
                                ref.read(authControllerProvider.notifier).logout();
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                              }
                            },
                            icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                            label: Text(isLoggedIn ? "LOGOUT" : "LOGIN NOW", style: const TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoggedIn ? Colors.redAccent : Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileOption(BuildContext context, IconData icon, String title, bool isEnabled) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.blueAccent.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isEnabled ? Colors.blueAccent : Colors.grey),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isEnabled ? Colors.black87 : Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        if (!isEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login first")));
          return;
        }
        
        if (title == "My Orders") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()));
        } else if (title == "Shipping Address") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressPage()));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: Text("This is the $title section."),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
            ),
          );
        }
      },
    );
  }
}
