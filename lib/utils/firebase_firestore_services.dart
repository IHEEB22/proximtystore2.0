import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proximitystore/models/custom_user.dart';
import 'package:proximitystore/models/product.dart';
import 'package:proximitystore/models/store.dart';
import 'package:proximitystore/providers/business_provider.dart';
import 'package:provider/provider.dart';

class FireStoreServices {
  final storeCollection = FirebaseFirestore.instance.collection('stores');
  final userCollection = FirebaseFirestore.instance.collection('users');
  final productCollection = FirebaseFirestore.instance.collection('products');
  final storeProductCollection =
      FirebaseFirestore.instance.collection('storeProductCollection');
  final ProductCollection = FirebaseFirestore.instance.collection('Product');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future createUser({required CustomUser newUser}) async {
    final docUser = userCollection.doc(newUser.userId);

    await docUser.set(newUser.toJson());
  }

  Future<String> getImageurl(BuildContext context) async {
    try {
      String imgaeName =
          context.read<BusinessProvider>().productDescription.text;
      final storageRef = storage.ref().child('PRODUCT IMAGES').child(imgaeName);
      PickedFile? pickedFile =
          await context.read<BusinessProvider>().pickedFile;
      File imageFile = File(pickedFile!.path);
      await storageRef.putFile(imageFile);
      String url = await storageRef.getDownloadURL() + '.jpeg';

      print(url);
      return url;
    } on FirebaseException catch (e) {
      print(e);
      return 'error';
    }
  }

  Future createStore({
    required String storeOwner,
    required String storeName,
    required GeoPoint storeLocation,
    required String storeImage,
    required List<String> storeSectors,
  }) async {
    final docStore = await storeCollection.doc();
    final Store newStore = Store(
      storeOwnerId: storeOwner,
      storeId: docStore.id,
      storeSectors: storeSectors,
      storeName: storeName,
      storeLocation: storeLocation,
      storeImage: storeImage,
    );
    await docStore.set(newStore.toJson());

    // update user data

    final docUser = await userCollection.doc(storeOwner);
    await docUser.update({
      'store_id': docStore.id,
      'has_store': true,
    });
  }

  Future createProduct(
    Product newProduct,
  ) async {
    print(newProduct.storeId);
    final docStoreConnected = storeCollection.doc(newProduct.storeId);
    await docStoreConnected
        .collection('products')
        .doc(newProduct.productName)
        .set(newProduct.toJson());

    // add the product to separated collection named products
    await productCollection
        .doc(newProduct.productName)
        .set(newProduct.toJson());

    if (!await getSignedInStoreHasProduct().last)
      await docStoreConnected.update({
        'has_product': true,
      });
  }

  Stream<List<CustomUser>> getUsers() =>
      userCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CustomUser.fromJson(doc.data()))
          .toList()
          .where(
              (user) => user.userId == FirebaseAuth.instance.currentUser!.uid)
          .toList());
  Future<List<Product>> getAllProductsLabel(String query) async {
    // return list of string feha el kelma mel product description where el query mawjud feha
    // List<String> labelList = [];
    List<Product> productNameList = [];
    var collection = productCollection;
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      productNameList.add(Product.fromJson(data));
      // productNameList.forEach((element) {
      //   List<String> l = element.split(' ');
      //   l.forEach((element) {
      //     element.toLowerCase().startsWith(query.toLowerCase()) &&
      //             !labelList.contains(element)
      //         ? labelList.add(element)
      //         : null;
      //   });
      // });
    }
    return productNameList
        .where((element) => element.productName.startsWith(query))
        .toList();
  }

  Future<List<Product>> getProductsSuggestion(
      {required String query, required BuildContext context}) async {
    // return list of string feha el kelma mel product description where el query mawjud feha
    List<Product> productList = [];

    var collection = productCollection;
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      productList.add(Product.fromJson(data));
    }
    return productList.where((product) {
      final productNameLower = product.productName.toLowerCase();
      final queryLower = query.toLowerCase();

      Map<String, bool> filterSelected =
          context.read<BusinessProvider>().chekedsectorsList;

      if (filterSelected.isEmpty)
        return productNameLower.contains(queryLower);
      else
        return productNameLower.contains(queryLower) &&
            filterSelected.containsKey(product.productCategoy);
    }).toList();
  }

  Stream<String> getSignedInStoreId() =>
      userCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CustomUser.fromJson(doc.data()))
          .toList()
          .where(
              (user) => user.userId == FirebaseAuth.instance.currentUser!.uid)
          .toList()
          .single
          .storeId!);
  Future<List<String>> getStoreSectors() => storeCollection
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Store.fromJson(doc.data()))
          .toList()
          .where((store) =>
              store.storeOwnerId == FirebaseAuth.instance.currentUser!.uid)
          .toList()
          .first
          .storeSectors)
      .first;

//       var collection = FirebaseFirestore.instance.collection('DriverList');
// var querySnapshot = await collection.get();
// for (var queryDocumentSnapshot in querySnapshot.docs) {
//   Map<String, dynamic> data = queryDocumentSnapshot.data();
//   var name = data['name'];
//   var phone = data['phone'];
// }

  Stream<bool> getSignedInStoreHasProduct() =>
      storeCollection.snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => Store.fromJson(doc.data()))
              .toList()
              .where((store) =>
                  store.storeOwnerId == FirebaseAuth.instance.currentUser!.uid)
              .toList()
              .last
              .hasProduct ??
          false);

  Stream<List<Product>> getProductList(String storeId) {
    return storeCollection.doc(storeId).collection('products').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  Future<Map<String, dynamic>> getProductsDetails(storeId) async {
    var storeDoc = await storeCollection.doc(storeId).get();
    Position clientPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Map<String, dynamic>? data = storeDoc.data();
    GeoPoint storeLocation = data?['store_location'];
    double distance = Geolocator.distanceBetween(
      clientPosition.latitude,
      clientPosition.latitude,
      storeLocation.latitude,
      storeLocation.longitude,
    );
    print(distance);
    return {
      'store_far_destination': distance.toString(),
      'store_sectors': 'dsdsd'
    };
  }

  // Stream<List<Product>> getAdminProduct() {
  //   return storeCollection.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  // }

// create query to get user has store proprety && dispose connectedStoreId when the user sign out
}
