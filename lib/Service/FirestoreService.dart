import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:e_commerce_app/Provider/CartProvider.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- Image Upload ---

  Future<String?> uploadProductImage(File imageFile, String productId) async {
    try {
      final ref = _storage.ref().child('product_images').child('$productId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // --- Products ---

  // Stream of all products
  Stream<List<Map<String, dynamic>>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ensure ID is included
        return data;
      }).toList();
    });
  }

  // --- Cart ---

  // Save cart to Firestore
  Future<void> saveCart(String userId, List<CartItem> cartItems) async {
    final List<Map<String, dynamic>> cartData = cartItems.map((item) => {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'iconCode': (item.icon is int) ? item.icon : null,
    }).toList();

    await _db.collection('users').doc(userId).set({
      'cart': cartData,
    }, SetOptions(merge: true));
  }

  // Load cart from Firestore
  Future<List<CartItem>> getCart(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists || doc.data()?['cart'] == null) return [];

    final List<dynamic> cartData = doc.data()!['cart'] as List<dynamic>;
    return cartData.map((item) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(item as Map);
      return CartItem(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        price: (map['price'] as num? ?? 0.0).toDouble(),
        quantity: map['quantity'] as int? ?? 1,
        icon: map['iconCode'],
      );
    }).toList();
  }

  // --- Initial Data Seeding ---

  Future<void> seedProducts(List<Map<String, dynamic>> products) async {
    final batch = _db.batch();
    for (var product in products) {
      final productToStore = Map<String, dynamic>.from(product);
      if (productToStore['icon'] != null) {
        productToStore['iconCode'] = productToStore['icon'].codePoint;
        productToStore.remove('icon');
      }
      
      final docRef = _db.collection('products').doc(product['id']);
      batch.set(docRef, productToStore);
    }
    await batch.commit();
  }
}
