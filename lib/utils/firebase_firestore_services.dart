import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proximitystore/models/custom_user.dart';
import 'package:proximitystore/models/product.dart';
import 'package:proximitystore/models/store.dart';
import 'package:proximitystore/utils/firebase_auth_services.dart';

class FireStoreServices {
  final storeCollection = FirebaseFirestore.instance.collection('stores');
  final userCollection = FirebaseFirestore.instance.collection('users');
  final productCollection = FirebaseFirestore.instance.collection('products');
  final storeProductCollection =
      FirebaseFirestore.instance.collection('storeProductCollection');
  final clientProductCollection =
      FirebaseFirestore.instance.collection('clientproduct');
  void createUser({required CustomUser newUser}) async {
    final docUser = userCollection.doc(newUser.userId);

    await docUser.set(newUser.toJson());
  }

  void createStore({
    required String storeOwner,
    required String storeName,
    required String storeLocation,
  }) async {
    final docStore = storeCollection.doc();
    final Store newStore = Store(
        storeOwnerId: storeOwner,
        storeId: docStore.id,
        storeSectors: [],
        storeName: storeName,
        storeLocation: '');
    await docStore.set(newStore.toJson());

    // update user data

    final docUser = userCollection.doc(storeOwner);
    await docUser.update({
      'store_id': docStore.id,
      'has_store': true,
    });
  }

  void createProduct(String storeConnected, Product newProduct) async {
    print(storeConnected);
    final docStoreConnected = storeCollection.doc(storeConnected);
    await docStoreConnected
        .collection('products')
        .doc(newProduct.productName)
        .set(newProduct.toJson());

    // add the product to separated collection named products
    await productCollection
        .doc(newProduct.productName)
        .set(newProduct.toJson());
  }

  Stream<List<CustomUser>> getUsers() =>
      userCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CustomUser.fromJson(doc.data()))
          .toList()
          .where(
              (user) => user.userId == FirebaseAuth.instance.currentUser!.uid)
          .toList());

  Stream<String> getSignedInStoreId() =>
      userCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CustomUser.fromJson(doc.data()))
          .toList()
          .where(
              (user) => user.userId == FirebaseAuth.instance.currentUser!.uid)
          .toList()
          .single
          .storeId!);

  Stream<bool> getSignedInStoreHasProduct() =>
      storeCollection.snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => Store.fromJson(doc.data()))
              .toList()
              .where((store) =>
                  store.storeOwnerId == FirebaseAuth.instance.currentUser!.uid)
              .toList()
              .single
              .hasProduct ??
          false);

  Stream<List<Product>> getProductList(String storeId) {
    return storeCollection.doc(storeId).collection('products').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  // Stream<List<Product>> getAdminProduct() {
  //   return storeCollection.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  // }

// create query to get user has store proprety && dispose connectedStoreId when the user sign out
}
