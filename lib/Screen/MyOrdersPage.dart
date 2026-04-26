import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../orders_provider.dart';
import 'OrderTrackingPage.dart';
import 'RatingPage.dart';

class MyOrdersPage extends ConsumerStatefulWidget {
  const MyOrdersPage({super.key});

  @override
  ConsumerState<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends ConsumerState<MyOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Purchases", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.orange[800],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange[800],
          tabs: const [
            Tab(text: "All"),
            Tab(text: "To Pay"),
            Tab(text: "To Ship"),
            Tab(text: "To Receive"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(allOrders), // All
          _buildOrderList(allOrders.where((o) => o.status == "To Pay").toList()),
          _buildOrderList(allOrders.where((o) => o.status == "To Ship" || o.status == "Processing").toList()),
          _buildOrderList(allOrders.where((o) => o.status == "To Receive").toList()),
          _buildOrderList(allOrders.where((o) => o.status == "Completed").toList()),
          _buildOrderList(allOrders.where((o) => o.status == "Cancelled").toList()),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            const Text("No orders found", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderTrackingPage(order: order)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            // Header: Store Name + Status
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.store, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text("Official Store", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(order.status, style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Items
            ...order.items.map((item) => _buildOrderItem(item)),

            const Divider(height: 1),
            
            // Footer: Total & Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${order.items.length} items: ", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const Text("Order Total: ", style: TextStyle(fontSize: 13)),
                      Text("₱${order.totalAmount.toStringAsFixed(2)}", 
                        style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (order.status == "Completed")
                        _actionButton(context, "Buy Again", isPrimary: false, order: order)
                      else if (order.status == "To Receive")
                        _actionButton(context, "Order Received", isPrimary: true, order: order)
                      else if (order.status == "Processing" || order.status == "To Ship") ...[
                        _actionButton(context, "Cancel Order", isPrimary: false, order: order),
                        _actionButton(context, "Contact Seller", isPrimary: false, order: order),
                      ] else if (order.status == "To Pay") ...[
                        _actionButton(context, "Cancel Order", isPrimary: false, order: order),
                        _actionButton(context, "Pay Now", isPrimary: true, order: order),
                      ] else if (order.status == "Cancelled")
                        _actionButton(context, "Buy Again", isPrimary: false, order: order)
                      else
                        _actionButton(context, "Check Details", isPrimary: false, order: order),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
            child: Icon(item['icon'] as IconData? ?? Icons.shopping_bag, size: 35, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text("₱${item['price']}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Text("x${item['quantity'] ?? 1}", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, {required bool isPrimary, required OrderItem order}) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: OutlinedButton(
        onPressed: () {
          if (label == "Order Received") {
            _handleOrderReceived(context, order);
          } else if (label == "Cancel Order") {
            _handleCancelOrder(context, order);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderTrackingPage(order: order)),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isPrimary ? Colors.orange[800]! : Colors.grey[300]!),
          backgroundColor: isPrimary ? Colors.orange[800] : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  void _handleOrderReceived(BuildContext context, OrderItem order) {
    // 1. Update status to Completed
    ref.read(ordersProvider.notifier).updateOrderStatus(order.id, "Completed");

    // 2. Show optional rating prompt
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Received"),
        content: const Text("Thank you for your purchase! Would you like to rate the items now?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // "Later" - just close
            child: const Text("Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RatingPage()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
            child: const Text("Rate Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleCancelOrder(BuildContext context, OrderItem order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to cancel this order?"),
            const SizedBox(height: 20),
            const Text("Reason for cancellation:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            _cancellationReasonTile(context, order, "Change of mind"),
            _cancellationReasonTile(context, order, "Found a better price"),
            _cancellationReasonTile(context, order, "Delivery time is too long"),
            _cancellationReasonTile(context, order, "Incorrect address"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Order", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _cancellationReasonTile(BuildContext context, OrderItem order, String reason) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(reason, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        ref.read(ordersProvider.notifier).updateOrderStatus(order.id, "Cancelled");
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order cancelled successfully"), backgroundColor: Colors.redAccent),
        );
      },
    );
  }
}
