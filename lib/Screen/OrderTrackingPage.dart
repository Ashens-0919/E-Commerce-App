import 'package:flutter/material.dart';
import 'package:e_commerce_app/Provider/OrdersProvider.dart';

class OrderTrackingPage extends StatelessWidget {
  final OrderItem order;

  const OrderTrackingPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              color: Colors.orange[800],
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(order.status),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _getStatusSubtitle(order.status),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Delivery Address
            _buildSection(
              icon: Icons.location_on,
              title: "Delivery Address",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("John Doe | (+63) 912 345 6789", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("123 Rizal Street, Barangay 456, Metro Manila, Philippines, 1000", 
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),

            // Order Timeline (The Progress Flow)
            _buildSection(
              icon: Icons.local_shipping,
              title: "Delivery Status",
              content: _buildTimeline(),
            ),

            // Product List
            _buildSection(
              icon: Icons.shopping_bag,
              title: "Items",
              content: Column(
                children: order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
                        child: Icon(item['icon'] as IconData? ?? Icons.shopping_bag, size: 25, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(item['name'], style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Text("x${item['quantity']}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                )).toList(),
              ),
            ),

            // Order Info
            _buildSection(
              icon: Icons.info_outline,
              title: "Order Information",
              content: Column(
                children: [
                  _infoRow("Order ID", order.id),
                  _infoRow("Order Time", "${order.date.day}/${order.date.month}/${order.date.year} ${order.date.hour}:${order.date.minute}"),
                  _infoRow("Payment Method", order.paymentMethod),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.orange[800]),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const Divider(height: 25),
          content,
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    List<Map<String, dynamic>> steps = [
      {"title": "Order Placed", "desc": "Your order has been placed", "status": "completed"},
      {"title": "Payment Confirmed", "desc": "Payment successfully verified", "status": "completed"},
      {"title": "To Ship", "desc": "Seller is preparing your parcel", "status": "pending"},
      {"title": "Out for Delivery", "desc": "Parcel is with our delivery partner", "status": "pending"},
      {"title": "Delivered", "desc": "Parcel has been delivered", "status": "pending"},
    ];

    // Adjust statuses based on order.status
    if (order.status == "Processing" || order.status == "To Ship") {
      steps[2]["status"] = "active";
    } else if (order.status == "To Receive") {
      steps[2]["status"] = "completed";
      steps[3]["status"] = "active";
    } else if (order.status == "Completed") {
      steps[2]["status"] = "completed";
      steps[3]["status"] = "completed";
      steps[4]["status"] = "completed";
    } else if (order.status == "To Pay") {
      steps[1]["status"] = "active";
      steps[2]["status"] = "pending";
    }

    return Column(
      children: List.generate(steps.length, (index) {
        bool isLast = index == steps.length - 1;
        var step = steps[index];
        Color color = step["status"] == "completed" ? Colors.orange[800]! : (step["status"] == "active" ? Colors.orange[800]! : Colors.grey[300]!);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    color: step["status"] == "active" ? Colors.white : color,
                    shape: BoxShape.circle,
                    border: step["status"] == "active" ? Border.all(color: color, width: 4) : null,
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 40, color: color.withOpacity(0.5)),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step["title"], 
                    style: TextStyle(
                      fontWeight: step["status"] == "active" ? FontWeight.bold : FontWeight.normal,
                      color: step["status"] == "pending" ? Colors.grey : Colors.black,
                    )
                  ),
                  Text(step["desc"], style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case "To Pay": return "Awaiting Payment";
      case "To Ship": 
      case "Processing": return "Seller is preparing your parcel";
      case "To Receive": return "Parcel is out for delivery";
      case "Completed": return "Order Delivered";
      default: return "Order Processing";
    }
  }

  String _getStatusSubtitle(String status) {
    switch (status) {
      case "To Pay": return "Please pay your order soon.";
      case "To Ship": 
      case "Processing": return "Your parcel will be handed to our delivery partner soon.";
      case "To Receive": return "Your parcel should arrive today.";
      case "Completed": return "Thank you for shopping with us!";
      default: return "We are working on your order.";
    }
  }
}
