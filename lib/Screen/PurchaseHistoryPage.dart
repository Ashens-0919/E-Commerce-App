import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Provider/OrdersProvider.dart';

class PurchaseHistoryPage extends ConsumerWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(ordersProvider);
    // In a real app, we might filter by 'Completed', but for testing we show all.
    final history = allOrders; 

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Purchase History", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: history.isEmpty
          ? _buildEmptyHistory()
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final order = history[index];
                return _buildHistoryCard(order);
              },
            ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("No purchase records found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(OrderItem order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Date: ${order.date.day}/${order.date.month}/${order.date.year}", 
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(order.status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const Divider(height: 20),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item['name'], style: const TextStyle(fontSize: 14))),
                  Text("x${item['quantity']}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Paid: ₱${order.totalAmount.toStringAsFixed(2)}", 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                OutlinedButton(
                  onPressed: () {}, 
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text("Reorder", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
