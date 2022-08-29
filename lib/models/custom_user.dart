import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:proximitystore/models/product.dart';

class CustomUser {
  final String userId;
  final String email;
  final String password;
  final String timeStamp;
  bool? hasStore;
  String? storeId;

  CustomUser({
    required this.userId,
    required this.email,
    required this.password,
    required this.timeStamp,
    this.hasStore,
    this.storeId,
  });

  static CustomUser fromJson(Map<String, dynamic> json) {
    final userId = json['user_id'] as String;
    final email = json['email'] as String;
    final password = json['password'] as String;
    final timeStamp = json['time_stamp'] as String;
    final hasStore = json['has_store'] as bool?;
    final storeId = json['store_id'] as String?;

    return CustomUser(
        userId: userId,
        password: password,
        email: email,
        timeStamp: timeStamp,
        hasStore: hasStore ?? false,
        storeId: storeId ?? 'no store created yet');
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'email': email,
        'password': password,
        'time_stamp': timeStamp,
        'has_store': hasStore,
        'store_id': storeId,
      };

  // @override
  // String toString() {
  //   return 'product(product_Name: $productName,product_image: $productImage,product_Price: $productPrice,store_far_destination: $storeFarDestination,product_status: $productStatus)';
  // }
}
