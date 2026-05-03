// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
import '../Provider/CartProvider.dart';
// import 'dart:developer' as developer;

class FirestoreService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- Image Upload (DISABLED) ---
  /*
  Future<String?> uploadProductImage(File imageFile, String productId) async {
    try {
      final ref = _storage.ref().child('product_images').child('$productId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      developer.log("Error uploading image", error: e);
      return null;
    }
  }
  */

  // --- Products (DISABLED) ---
  /*
  Stream<List<Map<String, dynamic>>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
  */

  // --- Cart (DISABLED) ---
  
  Future<void> saveCart(String userId, List<CartItem> cartItems) async {
    // Logic disabled to prevent database errors
  }

  Future<List<CartItem>> getCart(String userId) async {
    // Return empty list while database is disabled
    return [];
  }

  // --- Initial Data Seeding (DISABLED) ---
  /*
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
  */
}
