import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart_provider.dart';
import '../widgets/FigmaProductCard.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final List<Map<String, dynamic>> allProducts = [
    {"id": "1", "name": "Modern Gray Sofa", "price": 1299.99, "category": "Furniture", "icon": Icons.chair},
    {"id": "2", "name": "Wireless Headphones", "price": 99.0, "category": "Electronics", "icon": Icons.headphones},
    {"id": "3", "name": "Running Shoes", "price": 75.0, "category": "Shoes", "icon": Icons.directions_run},
    {"id": "4", "name": "Smart Watch", "price": 150.0, "category": "Electronics", "icon": Icons.watch},
    {"id": "5", "name": "Cotton T-Shirt", "price": 25.0, "category": "Fashion", "icon": Icons.checkroom},
    {"id": "6", "name": "Gaming Mouse", "price": 45.0, "category": "Electronics", "icon": Icons.mouse},
    {"id": "7", "name": "Leather Wallet", "price": 30.0, "category": "Fashion", "icon": Icons.account_balance_wallet},
    {"id": "8", "name": "iPhone 15 Pro", "price": 999.0, "category": "Electronics", "icon": Icons.phone_iphone},
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
  }

  void _filterSearch(String query) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product['name']!.toString().toLowerCase().contains(query.toLowerCase()) ||
              product['category']!.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.yellowAccent, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterSearch,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterSearch("");
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 80, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("No products found", style: TextStyle(color: Colors.grey, fontSize: 18)),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220, // Automatically adds columns on tablets
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return FigmaProductCard(product: product);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
