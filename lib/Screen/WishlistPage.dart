import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../wishlist_provider.dart';
import '../products_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final allProducts = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Wishlist", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: wishlist.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlist[index];
                // Sync with productsProvider to check current stock status
                final currentProduct = allProducts.firstWhere(
                  (p) => p['id'] == item['id'],
                  orElse: () => item,
                );
                final bool isOutOfStock = currentProduct['outOfStock'] ?? false;

                return _buildWishlistItem(context, ref, currentProduct, isOutOfStock);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("Your wishlist is empty", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, WidgetRef ref, Map<String, dynamic> item, bool isOutOfStock) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Icon
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Icon(item['icon'] as IconData? ?? Icons.shopping_bag, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 15),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text("₱${item['price']}", style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  
                  // Stock Status Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isOutOfStock ? Colors.red[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      isOutOfStock ? "Out of Stock" : "In Stock",
                      style: TextStyle(
                        color: isOutOfStock ? Colors.red : Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref.read(wishlistProvider.notifier).toggleWishlist(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Removed from wishlist"), duration: Duration(seconds: 1)),
                    );
                  },
                ),
                if (!isOutOfStock)
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart, color: Colors.orange[800]),
                    onPressed: () {
                      // Add to cart logic could be triggered here
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
