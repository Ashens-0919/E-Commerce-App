import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_app/Provider/AddressProvider.dart';

class ShippingAddressPage extends ConsumerWidget {
  const ShippingAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Addresses", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: addresses.isEmpty
          ? const Center(child: Text("No addresses saved yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(context, ref, address);
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _showAddAddressDialog(context, ref),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
            child: const Text("ADD NEW ADDRESS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, AddressModel address) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: address.isDefault ? Colors.orange : Colors.transparent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(address.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 10),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                    child: const Text("Default", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => ref.read(addressProvider.notifier).setDefault(address.id),
                  child: const Text("Set Default", style: TextStyle(color: Colors.blue, fontSize: 13)),
                ),
              ],
            ),
            Text(address.phone, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Text("${address.street}, ${address.city}, ${address.province}, ${address.zip}", 
              style: const TextStyle(fontSize: 14)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => ref.read(addressProvider.notifier).deleteAddress(address.id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final zipController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add New Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
              TextField(controller: streetController, decoration: const InputDecoration(labelText: "Street Address")),
              TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: provinceController, decoration: const InputDecoration(labelText: "Province")),
              TextField(controller: zipController, decoration: const InputDecoration(labelText: "ZIP Code")),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final newAddress = AddressModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      phone: phoneController.text,
                      label: "Home",
                      street: streetController.text,
                      city: cityController.text,
                      province: provinceController.text,
                      zip: zipController.text,
                    );
                    ref.read(addressProvider.notifier).addAddress(newAddress);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
                  child: const Text("SAVE ADDRESS", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
