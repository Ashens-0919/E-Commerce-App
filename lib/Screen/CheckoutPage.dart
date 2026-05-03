import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Provider/OrdersProvider.dart';
import '../Provider/CartProvider.dart';
import '../Provider/AddressProvider.dart';
import 'ShippingAddressPage.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? singleProduct;
  final List<CartItem>? selectedCartItems;

  const CheckoutPage({super.key, this.singleProduct, this.selectedCartItems});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String selectedPayment = "Cash on Delivery";
  double shippingFee = 45.00;
  double voucherDiscount = 20.00;
  double taxRate = 0.12;

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    List<Map<String, dynamic>> itemsToDisplay = [];

    if (widget.singleProduct != null) {
      subtotal = (widget.singleProduct!['price'] as num).toDouble();
      itemsToDisplay.add(widget.singleProduct!);
    } else if (widget.selectedCartItems != null) {
      subtotal = widget.selectedCartItems!.fold(0, (sum, item) => sum + (item.price * item.quantity));
      for (var item in widget.selectedCartItems!) {
        itemsToDisplay.add({
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'icon': item.icon,
        });
      }
    } else {
      final cartItems = ref.watch(cartProvider);
      subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
      for (var item in cartItems) {
        itemsToDisplay.add({
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'icon': item.icon,
        });
      }
    }
    
    double tax = subtotal * taxRate;
    double total = subtotal + shippingFee + tax - voucherDiscount;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAddressSection(),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.store, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Official Store", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  ...itemsToDisplay.map((item) => _buildOrderItem(item)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildVoucherSection(),
            const SizedBox(height: 10),
            _buildPaymentSection(),
            const SizedBox(height: 10),
            _buildOrderDetails(subtotal),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(total, itemsToDisplay),
    );
  }

  Widget _buildAddressSection() {
    final addresses = ref.watch(addressProvider);
    final defaultAddress = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.isNotEmpty ? addresses.first : AddressModel(id: '0', name: 'No Name', phone: 'No Phone', label: '', street: 'No Address Set', city: '', province: '', zip: ''));

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressPage())), 
                child: const Text("Change", style: TextStyle(color: Colors.blue))
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${defaultAddress.name} | ${defaultAddress.phone}", style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text("${defaultAddress.street}, ${defaultAddress.city}, ${defaultAddress.province}, ${defaultAddress.zip}", 
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Icon(item['icon'] as IconData? ?? Icons.shopping_bag, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                const Text("Standard Delivery", style: TextStyle(color: Colors.green, fontSize: 12)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₱${item['price']}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("x${item['quantity'] ?? 1}", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number_outlined, color: Colors.orange),
          const SizedBox(width: 10),
          const Text("Platform Voucher"),
          const Spacer(),
          Text("₱$voucherDiscount Off", style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return InkWell(
      onTap: () => _showPaymentSelectionSheet(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.blue, size: 20),
                const SizedBox(width: 10),
                const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(selectedPayment, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),
                const SizedBox(width: 5),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _paymentModalOption(setModalState, "Cash on Delivery", Icons.money),
                  _paymentModalOption(setModalState, "GCash", Icons.account_balance_wallet),
                  _paymentModalOption(setModalState, "Credit/Debit Card", Icons.credit_card),
                  _paymentModalOption(setModalState, "Lazada Wallet", Icons.wallet),
                  _paymentModalOption(setModalState, "Maya", Icons.account_balance),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _paymentModalOption(StateSetter setModalState, String title, IconData icon) {
    bool isSelected = selectedPayment == title;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.orange : Colors.black)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.orange) : null,
      onTap: () {
        setState(() => selectedPayment = title);
        setModalState(() {});
        Navigator.pop(context);
      },
    );
  }

  Widget _buildOrderDetails(double subtotal) {
    double tax = subtotal * taxRate;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _computationRow("Merchandise Subtotal", subtotal),
          _computationRow("Shipping Fee", shippingFee),
          _computationRow("Estimated VAT (12%)", tax),
          _computationRow("Voucher Discount", -voucherDiscount, isDiscount: true),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("₱${(subtotal + shippingFee + tax - voucherDiscount).toStringAsFixed(2)}", 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _computationRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text("${amount < 0 ? '-' : ''}₱${amount.abs().toStringAsFixed(2)}", 
            style: TextStyle(color: isDiscount ? Colors.red : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(double total, List<Map<String, dynamic>> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Total Payment", style: TextStyle(fontSize: 12)),
              Text("₱${total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 150, height: 50,
            child: ElevatedButton(
              onPressed: () => _handlePlaceOrder(total, items),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], shape: const RoundedRectangleBorder()),
              child: const Text("Place Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder(double total, List<Map<String, dynamic>> items) {
    final orderItems = items.map((item) => {
      'name': item['name'],
      'price': (item['price'] as num).toDouble(),
      'quantity': item['quantity'] ?? 1,
      'icon': item['icon'],
    }).toList();

    ref.read(ordersProvider.notifier).addOrder(orderItems, total, paymentMethod: selectedPayment);
    
    // Cleanup: Remove ordered items from cart
    if (widget.selectedCartItems != null) {
      for (var item in widget.selectedCartItems!) {
        ref.read(cartProvider.notifier).removeFromCart(item.id);
      }
    } else if (widget.singleProduct == null) {
      // If it was full cart checkout (legacy fallback)
      final cart = ref.read(cartProvider);
      for (var item in cart) {
        ref.read(cartProvider.notifier).removeFromCart(item.id);
      }
    }

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Order Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(selectedPayment == "Cash on Delivery" 
              ? "Your order has been placed via COD." 
              : "Payment successful via $selectedPayment.", 
              textAlign: TextAlign.center),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Back to Home"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
