import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String label; // e.g., "Home", "Office"
  final String street;
  final String city;
  final String province;
  final String zip;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.label,
    required this.street,
    required this.city,
    required this.province,
    required this.zip,
    this.isDefault = false,
  });

  AddressModel copyWith({bool? isDefault}) {
    return AddressModel(
      id: id,
      name: name,
      phone: phone,
      label: label,
      street: street,
      city: city,
      province: province,
      zip: zip,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super([
    AddressModel(
      id: '1',
      name: 'John Doe',
      phone: '(+63) 912 345 6789',
      label: 'Home',
      street: '123 Rizal Street, Barangay 456',
      city: 'Metro Manila',
      province: 'NCR',
      zip: '1000',
      isDefault: true,
    ),
  ]);

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      state = state.map((a) => a.copyWith(isDefault: false)).toList();
    }
    state = [...state, address];
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }

  void deleteAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier();
});
