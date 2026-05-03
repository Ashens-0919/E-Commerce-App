import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Map<String, dynamic>>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  WishlistNotifier() : super([]);

  void toggleWishlist(Map<String, dynamic> product) {
    final isExist = state.any((item) => item['id'] == product['id']);
    if (isExist) {
      state = state.where((item) => item['id'] != product['id']).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(String productId) {
    return state.any((item) => item['id'] == productId);
  }
}
