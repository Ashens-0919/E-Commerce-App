import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final productsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getProducts();
});
