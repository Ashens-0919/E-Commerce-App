import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart_provider.dart';

import '../wishlist_provider.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  late String selectedVariant;

  @override
  void initState() {
    super.initState();
    selectedVariant = (widget.product['variants'] as List?)?.first ?? "Default";
  }

  @override
  Widget build(BuildContext context) {
    final variantType = widget.product['variantType'] ?? "Variant";
    final variants = (widget.product['variants'] as List?) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer(builder: (context, ref, _) {
            final isFav = ref.watch(wishlistProvider.notifier).isFavorite(widget.product['id']);
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, 
                color: isFav ? Colors.red : Colors.black),
              onPressed: () {
                ref.read(wishlistProvider.notifier).toggleWishlist(widget.product);
              },
            );
          }),
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(widget.product['icon'] as IconData, size: 120, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 15),

            // View in AR Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pinkAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.view_in_ar, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text("View in Your Space (AR)", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.product['category'] ?? "Furniture",
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 15),

            // Product Name
            Text(
              widget.product['name'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Ratings
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) => Icon(
                    Icons.star,
                    size: 20,
                    color: index < 4 ? Colors.amber : Colors.grey[300],
                  )),
                ),
                const SizedBox(width: 8),
                const Text("4.7", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                const Text("(234 reviews)", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),

            // Price
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "\$${widget.product['price']}",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Instock",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              "A high-quality product designed for both style and performance. Built with premium materials for maximum durability.",
              style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 25),

            // Specs
            _buildSpecRow("Dimensions:", "Standard"),
            const SizedBox(height: 10),
            _buildSpecRow("Material:", "Premium Quality"),
            const Divider(height: 40),

            // Dynamic Variant Selection
            if (variants.isNotEmpty) ...[
              Text("$variantType: $selectedVariant", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: variants.map((v) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _variantOption(v),
                  )).toList(),
                ),
              ),
            ],
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 20, 
          right: 20, 
          bottom: MediaQuery.of(context).padding.bottom + 10, 
          top: 10
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addToCart(CartItem(
                id: widget.product['id'],
                name: "${widget.product['name']} ($selectedVariant)",
                price: widget.product['price'],
                icon: widget.product['icon'],
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${widget.product['name']} added to cart!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D0D2B), // Very dark navy/black
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Add to Cart", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _variantOption(String variant) {
    bool isSelected = selectedVariant == variant;
    return GestureDetector(
      onTap: () => setState(() => selectedVariant = variant),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.purple : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.purple.withOpacity(0.05) : Colors.white,
        ),
        child: Text(variant, style: TextStyle(
          color: isSelected ? Colors.purple : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        )),
      ),
    );
  }
}
