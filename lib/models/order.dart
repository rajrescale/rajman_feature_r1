import 'dart:convert';

import 'package:dalvi/models/product.dart';

class Order {
  final String id;
  final List<OrderProduct> products;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final int totalPrice;
  int lastUpdate;

  Order({
    required this.id,
    required this.products,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
    required this.lastUpdate,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<OrderProduct>.from(
        map['products']?.map((x) => OrderProduct.fromMap(x)),
      ),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      lastUpdate: map['lastUpdate']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
      'lastUpdate': lastUpdate,
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

class OrderProduct {
  final Product product;
  final int quantity;
  final SizeAndPrice sizeAndPrice;

  OrderProduct({
    required this.product,
    required this.quantity,
    required this.sizeAndPrice,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
      sizeAndPrice: SizeAndPrice.fromMap(map['sizeAndPrice']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'sizeAndPrice': sizeAndPrice.toMap(),
    };
  }
}

class SizeAndPrice {
  final String size;
  final int price;

  SizeAndPrice({
    required this.size,
    required this.price,
  });

  factory SizeAndPrice.fromMap(Map<String, dynamic> map) {
    return SizeAndPrice(
      size: map['size'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'price': price,
    };
  }
}
