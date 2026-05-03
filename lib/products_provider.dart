import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      "id": "1", 
      "name": "Modern Gray Sofa", 
      "price": 1299.99, 
      "category": "Furniture", 
      "icon": Icons.chair,
      "variantType": "Color",
      "variants": ["Gray", "Charcoal", "Navy", "Velvet Red"],
      "outOfStock": true
    },
    {
      "id": "2", 
      "name": "Wireless Headphones", 
      "price": 99.0, 
      "icon": Icons.headphones, 
      "category": "Electronics",
      "variantType": "Color",
      "variants": ["Black", "Silver", "Rose Gold"]
    },
    {
      "id": "3", 
      "name": "Smart Watch", 
      "price": 150.0, 
      "icon": Icons.watch, 
      "category": "Electronics",
      "variantType": "Size",
      "variants": ["40mm", "44mm", "45mm"]
    },
    {
      "id": "4", 
      "name": "Running Shoes", 
      "price": 75.0, 
      "icon": Icons.directions_run, 
      "category": "Shoes",
      "variantType": "Size",
      "variants": ["US 8", "US 9", "US 10", "US 11"]
    },
    {
      "id": "5", 
      "name": "iPhone 15", 
      "price": 999.0, 
      "icon": Icons.phone_iphone, 
      "category": "Electronics",
      "variantType": "Storage",
      "variants": ["128GB", "256GB", "512GB"]
    },
  ];
});
