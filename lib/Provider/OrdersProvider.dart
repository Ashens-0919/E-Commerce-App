import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItem {
  final String id;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime date;
  String status;
  final String paymentMethod;

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.status = "Processing",
    this.paymentMethod = "Cash on Delivery",
  });

  OrderItem copyWith({String? status, String? paymentMethod}) {
    return OrderItem(
      id: id,
      items: items,
      totalAmount: totalAmount,
      date: date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class OrdersNotifier extends StateNotifier<List<OrderItem>> {
  OrdersNotifier() : super([]);

  void addOrder(List<Map<String, dynamic>> cartItems, double total, {String paymentMethod = "Cash on Delivery"}) {
    final newOrder = OrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: cartItems,
      totalAmount: total,
      date: DateTime.now(),
      paymentMethod: paymentMethod,
    );
    state = [newOrder, ...state];
  }

  void updateOrderStatus(String id, String newStatus) {
    state = [
      for (final order in state)
        if (order.id == id) order.copyWith(status: newStatus) else order,
    ];
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderItem>>((ref) {
  return OrdersNotifier();
});
