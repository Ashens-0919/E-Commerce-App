import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_controller.dart';
import 'LoginPage.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth state
    final isLoggedIn = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                isLoggedIn ? Icons.person : Icons.person_outline, 
                size: 50, 
                color: Colors.white
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isLoggedIn ? "Verified User" : "Guest User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              isLoggedIn ? "user@example.com" : "Please login to see your data",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Profile Options
            _profileOption(Icons.shopping_bag_outlined, "My Orders", isLoggedIn),
            _profileOption(Icons.favorite_border, "Wishlist", isLoggedIn),
            _profileOption(Icons.location_on_outlined, "Shipping Address", isLoggedIn),
            _profileOption(Icons.payment_outlined, "Payment Methods", isLoggedIn),
            const Divider(),
            _profileOption(Icons.settings_outlined, "Settings", true), // Settings always visible
            _profileOption(Icons.help_outline, "Help Center", true),   // Help always visible
            
            const SizedBox(height: 40),
            
            // Conditional Button: Logout if logged in, Login if guest
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isLoggedIn) {
                      // Logout logic
                      ref.read(authControllerProvider.notifier).logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged out successfully"))
                      );
                    } else {
                      // Login logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                  label: Text(isLoggedIn ? "Logout" : "Login Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoggedIn ? Colors.redAccent : Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, bool isEnabled) {
    return ListTile(
      leading: Icon(icon, color: isEnabled ? Colors.blueAccent : Colors.grey),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isEnabled ? Colors.black : Colors.grey
        )
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: isEnabled ? () {} : null, // Disable clicks if not logged in
    );
  }
}
