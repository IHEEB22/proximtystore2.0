import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:proximitystore/models/product.dart';

class Store {
  final String storeName;
  final String storeOwnerId;
  final String storeId;
  final List<String> storeSectors;
  List<Product> storeProducts = [];
  bool? storeStatus;
  // final String storeLocation;
  String? storeImage;
  // String? storeDescription;
  bool? hasProduct;

  Store({
    required this.storeId,
    required this.storeOwnerId,
    required this.storeSectors,
    required this.storeName,
    // required this.storeLocation,
    this.storeStatus,
    this.storeImage,
    // this.storeDescription,
    this.hasProduct,
  });
// fase5 el stores el kol eli mafihomch hasstore (5ali can store mta3 ihebhmida8@gmail.com w ihebhmida00@gmail.com)
// 5ali 7wOMVwCZI025seZjoBjj w VXOqUFUtatOsArIKTAYU
  factory Store.fromJson(Map<String, dynamic> json) {
    // final storeStatus = json['store_status'] as bool?;
    final storeName = json['store_name'] as String;
    // final storeLocation = json['store_location'] as String;
    // final storeImage = json['store_image'] as String?;
    // final storeDescription = json['store_description'] as String?;
    // final storeProducts = json['store_products'] as List<Product>;
    // final storeSectors = json['store_sectors'] as List<String>;
    final storeId = json['store_id'] as String;
    final storeOwnerId = json['store_owner_Id'] as String;
    final hasProduct = json['has_product'] as bool?;

    return Store(
        storeId: storeId,
        storeOwnerId: storeOwnerId,
        // storeStatus: storeStatus,
        storeName: storeName,
        // storeLocation: storeLocation,
        // storeImage: storeImage,
        // storeDescription: storeDescription,
        hasProduct: hasProduct ?? false,
        storeSectors: []);
  }

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'store_owner_Id': storeOwnerId,
        'store_name': storeName,
        'store_status': storeStatus,
        // 'store_location': storeLocation,
        'store_image': storeImage,
        // 'store_description': storeDescription,
        'store_sectors': storeSectors,
        'has_product': hasProduct,
      };

  void addProduct({required Product product}) {
    this.storeProducts.add(product);
  }

  // @override
  // String toString() {
  //   return 'product(product_Name: $productName,product_image: $productImage,product_Price: $productPrice,store_far_destination: $storeFarDestination,product_status: $productStatus)';
  // }
}
