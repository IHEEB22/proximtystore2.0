class Product {
  final String storeId;
  final String productName;
  final String productImage;
  final double productPrice;
  String? productStatus;
  final String productCategoy;

  Product({
    required this.storeId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productCategoy,
    this.productStatus,
  });

  static Product fromJson(Map<String, dynamic> json) {
    final storeId = json['store_id'] as String;
    final productImage = json['product_image'] as String;
    final productName = json['product_name'] as String;
    final productPrice = json['product_price'] as double;
    final productStatus = json['product_status'] as String?;
    final productCategoy = json['product_category'] as String;

    return Product(
      storeId: storeId,
      productImage: productImage,
      productName: productName,
      productPrice: productPrice,
      productCategoy: productCategoy,
      productStatus: productStatus ?? 'en attente',
    );
  }

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'product_name': productName,
        'product_image': productImage,
        'product_price': productPrice,
        'product_status': productStatus,
        'product_category': productCategoy,
      };
}
