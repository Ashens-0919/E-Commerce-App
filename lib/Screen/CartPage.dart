import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart_provider.dart';
import 'CheckoutPage.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  // Track selected items
  final Set<String> selectedItemIds = {};
  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Calculate total for SELECTED items only
    double selectedSubtotal = 0;
    for (var item in cartItems) {
      if (selectedItemIds.contains(item.id)) {
        selectedSubtotal += item.price * item.quantity;
      }
    }

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
                  const Text("Shopping Cart", 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (cartItems.isNotEmpty)
                    TextButton(
                      onPressed: () => _handleDelete(ref),
                      child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                child: Column(
                  children: [
                    // Select All Bar
                    if (cartItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.blueAccent,
                              value: isAllSelected,
                              onChanged: (val) {
                                setState(() {
                                  isAllSelected = val ?? false;
                                  if (isAllSelected) {
                                    selectedItemIds.addAll(cartItems.map((e) => e.id));
                                  } else {
                                    selectedItemIds.clear();
                                  }
                                });
                              },
                            ),
                            const Text("Select All", style: TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text("${selectedItemIds.length} items selected", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    
                    Expanded(
                      child: cartItems.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text("Your cart is empty", style: TextStyle(color: Colors.grey, fontSize: 18)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                final isSelected = selectedItemIds.contains(item.id);

                                return Card(
                                  elevation: 2,
                                  shadowColor: Colors.black12,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.blueAccent,
                                          value: isSelected,
                                          onChanged: (val) {
                                            setState(() {
                                              if (val == true) {
                                                selectedItemIds.add(item.id);
                                              } else {
                                                selectedItemIds.remove(item.id);
                                                isAllSelected = false;
                                              }
                                            });
                                          },
                                        ),
                                        Container(
                                          width: 70, height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(item.icon as IconData?, color: Colors.blueAccent, size: 30),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("₱${item.price.toStringAsFixed(2)}", 
                                                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                                                  Row(
                                                    children: [
                                                      _qtyBtn(Icons.remove, () {
                                                        if (item.quantity > 1) {
                                                          cartNotifier.updateQuantity(item.id, -1);
                                                        }
                                                      }),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      ),
                                                      _qtyBtn(Icons.add, () {
                                                        cartNotifier.updateQuantity(item.id, 1);
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    
                    // Bottom Checkout Bar
                    _buildBottomCheckoutBar(selectedSubtotal, cartItems),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 14),
      ),
    );
  }

  void _handleDelete(WidgetRef ref) {
    if (selectedItemIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select items to delete")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Items?"),
        content: Text("Are you sure you want to remove ${selectedItemIds.length} items from your cart?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              final cartNotifier = ref.read(cartProvider.notifier);
              for (var id in selectedItemIds) {
                cartNotifier.removeFromCart(id);
              }
              setState(() {
                selectedItemIds.clear();
                isAllSelected = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Items removed")),
              );
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCheckoutBar(double subtotal, List<CartItem> allItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Amount", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text("₱${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ],
            ),
            SizedBox(
              width: 160,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedItemIds.isEmpty ? null : () {
                  final selectedItems = allItems.where((item) => selectedItemIds.contains(item.id)).toList();
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        selectedCartItems: selectedItems,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  shadowColor: Colors.blueAccent.withOpacity(0.4),
                ),
                child: Text("Check Out (${selectedItemIds.length})", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
