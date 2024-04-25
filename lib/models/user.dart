import 'dart:convert';

class Users {
  final String id;
  final String name;
  final String email;
  final List<String> otp; // Change type to List<String>
  final String password;
  final String phone;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  Users({
    required this.id,
    required this.name,
    required this.otp,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'otp': otp, // Update to list of strings
      'phone': phone,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      otp: List<String>.from(map['otp'] ?? []), // Convert to list of strings
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
              (x) => Map<String, dynamic>.from(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source));

  Users copyWith({
    String? id,
    String? name,
    List<String>? otp, // Change type to List<String>
    String? phone,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return Users(
      id: id ?? this.id,
      name: name ?? this.name,
      otp: otp ?? this.otp,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
