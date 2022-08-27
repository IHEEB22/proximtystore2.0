import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:proximitystore/models/product.dart';

class CustomUser {
  final String userId;
  final String email;
  final String password;
  bool? hasStore;
  String? storeId;

  CustomUser({
    required this.userId,
    required this.email,
    required this.password,
    this.hasStore,
    this.storeId,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    final userId = json['user_id'] as String;
    final email = json['user_email'] as String;
    final password = json['user_password'] as String;
    final hasStore = json['user_hasStore'] as bool?;
    final storeId = json['user_store_id'] as String?;

    return CustomUser(
        userId: userId,
        password: password,
        email: email,
        hasStore: hasStore,
        storeId: storeId);
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'email': email,
        'password': password,
        'hasStore': hasStore,
        'store_id': storeId,
      };

  // @override
  // String toString() {
  //   return 'product(product_Name: $productName,product_image: $productImage,product_Price: $productPrice,store_far_destination: $storeFarDestination,product_status: $productStatus)';
  // }
}
