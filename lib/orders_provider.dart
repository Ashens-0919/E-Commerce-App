import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItem {
  final String id;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime date;
  final String status;

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.status = "Processing",
  });
}

class OrdersNotifier extends StateNotifier<List<OrderItem>> {
  OrdersNotifier() : super([]);

  void addOrder(List<Map<String, dynamic>> cartItems, double total) {
    final newOrder = OrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: cartItems,
      totalAmount: total,
      date: DateTime.now(),
    );
    state = [newOrder, ...state];
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderItem>>((ref) {
  return OrdersNotifier();
});
