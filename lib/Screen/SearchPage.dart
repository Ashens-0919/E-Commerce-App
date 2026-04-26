import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/FigmaProductCard.dart';
import '../products_provider.dart';
import '../search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productsProvider);
    final history = ref.watch(searchHistoryProvider);
    final query = ref.watch(searchQueryProvider);

    List<Map<String, dynamic>> filteredProducts = allProducts
        .where((product) =>
            product['name']!.toString().toLowerCase().contains(query.toLowerCase()) ||
            product['category']!.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
          onSubmitted: (val) {
            ref.read(searchHistoryProvider.notifier).addSearch(val);
          },
          decoration: const InputDecoration(
            hintText: "Search on Shopee-Clone",
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = "";
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          if (query.isEmpty) ...[
            _buildHistorySection(history),
            _buildPopularSection(),
          ] else
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(15),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return FigmaProductCard(product: filteredProducts[index]);
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<String> history) {
    if (history.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Searches", style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => ref.read(searchHistoryProvider.notifier).clearHistory(),
                child: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
        Wrap(
          children: history.map((q) => _searchChip(q)).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text("Popular Searches", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // Add some hardcoded popular tags
        Wrap(
          children: [
            _PopularTag(text: "iPhone 15"),
            _PopularTag(text: "Sofa"),
            _PopularTag(text: "Shoes"),
            _PopularTag(text: "Headphones"),
          ],
        )
      ],
    );
  }

  Widget _searchChip(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        ref.read(searchQueryProvider.notifier).state = text;
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
        child: Text(text),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const Text("No products found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _PopularTag extends StatelessWidget {
  final String text;
  const _PopularTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5)),
      child: Text(text),
    );
  }
}
