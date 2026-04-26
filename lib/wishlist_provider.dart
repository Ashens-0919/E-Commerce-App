import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  WishlistNotifier(this.ref) : super([]) {
    // Automatically load wishlist when user logs in
    ref.listen(authControllerProvider, (previous, next) {
      if (next != null) {
        _loadWishlist(next.uid);
      } else {
        state = [];
      }
    });
  }

  Future<void> _loadWishlist(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists && doc.data()?['wishlist'] != null) {
        final List<dynamic> list = doc.data()!['wishlist'];
        state = list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print("Error loading wishlist: $e");
    }
  }

  void toggleWishlist(Map<String, dynamic> product) {
    final isExist = state.any((item) => item['id'] == product['id']);
    if (isExist) {
      state = state.where((item) => item['id'] != product['id']).toList();
    } else {
      state = [...state, product];
    }
    _syncWithFirestore();
  }

  bool isFavorite(String productId) {
    return state.any((item) => item['id'] == productId);
  }

  Future<void> _syncWithFirestore() async {
    final user = ref.read(authControllerProvider);
    if (user != null) {
      try {
        await _db.collection('users').doc(user.uid).set({
          'wishlist': state,
        }, SetOptions(merge: true));
      } catch (e) {
        print("Error syncing wishlist: $e");
      }
    }
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Map<String, dynamic>>>((ref) {
  return WishlistNotifier(ref);
});
