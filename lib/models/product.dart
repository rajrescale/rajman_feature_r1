import 'dart:convert';

class Product {
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final List<Map<String, dynamic>> sizesAndPrices; // Updated field
  final String? id;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.sizesAndPrices,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'sizesAndPrices': sizesAndPrices, // Updated field
      'id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'],
      images: List<String>.from(map['images']),
      sizesAndPrices: List<Map<String, dynamic>>.from(
          map['sizesAndPrices']), // Updated field
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
