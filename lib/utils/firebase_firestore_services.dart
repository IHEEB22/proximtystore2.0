import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
  final clientProductCollection =
      FirebaseFirestore.instance.collection('clientproduct');
  FirebaseStorage storage = FirebaseStorage.instance;

  void createUser({required CustomUser newUser}) async {
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

  Future createProduct(String storeConnected, Product newProduct) async {
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
