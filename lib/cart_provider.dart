import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'firestore_service.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final dynamic icon;

  CartItem({required this.id, required this.name, required this.price, this.quantity = 1, required this.icon});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Ref ref;
  
  CartNotifier(this.ref) : super([]) {
    // Automatically load cart when user changes
    ref.listen(authControllerProvider, (previous, next) {
      if (next != null) {
        _loadCart(next.uid);
      } else {
        state = [];
      }
    });
  }

  Future<void> _loadCart(String userId) async {
    final cart = await FirestoreService().getCart(userId);
    state = cart;
  }

  void addToCart(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            CartItem(
              id: state[i].id,
              name: state[i].name,
              price: state[i].price,
              quantity: state[i].quantity + 1,
              icon: state[i].icon,
            )
          else
            state[i]
      ];
    } else {
      state = [...state, item];
    }
    _syncWithFirestore();
  }

  void removeFromCart(String id) {
    state = state.where((item) => item.id != id).toList();
    _syncWithFirestore();
  }

  void clearCart() {
    state = [];
    _syncWithFirestore();
  }

  void updateQuantity(String id, int delta) {
    state = [
      for (final item in state)
        if (item.id == id)
          CartItem(
            id: item.id,
            name: item.name,
            price: item.price,
            quantity: (item.quantity + delta).clamp(1, 99),
            icon: item.icon,
          )
        else
          item
    ];
    _syncWithFirestore();
  }

  void _syncWithFirestore() {
    final user = ref.read(authControllerProvider);
    if (user != null) {
      FirestoreService().saveCart(user.uid, state);
    }
  }

  double get totalAmount => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier(ref));
