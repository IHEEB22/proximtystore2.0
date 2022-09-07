import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:proximitystore/models/store.dart';

class Product {
  final String productName;
  final String productImage;
  final double productPrice;
  String? productStatus;

  Product({
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.productStatus,
  });

  static Product fromJson(Map<String, dynamic> json) {
    final productImage = json['product_image'] as String;
    final productName = json['product_name'] as String;
    final productPrice = json['product_price'] as double;
    final productStatus = json['product_status'] as String?;

    return Product(
      productName: productName,
      productImage: productImage,
      productPrice: productPrice,
      productStatus: productStatus ?? 'en attente',
    );
  }

  Map<String, dynamic> toJson() => {
        'product_name': productName,
        'product_image': productImage,
        'product_price': productPrice,
        'product_status': productStatus,
      };
}
