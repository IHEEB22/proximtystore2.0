import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:proximitystore/models/custom_user.dart';
import 'package:proximitystore/models/product.dart';
import 'package:proximitystore/models/store.dart';
import 'package:proximitystore/providers/business_provider.dart';

class FireStoreServices {
  final storeCollection = FirebaseFirestore.instance.collection('stores');
  final userCollection = FirebaseFirestore.instance.collection('users');
  void createUser({required CustomUser newUser}) async {
    final docUser = userCollection.doc(newUser.userId);

    await docUser.set(newUser.toJson());
  }

  void createStore({
    required BuildContext context,
    required String storeOwnerId,
    required String storeName,
    required String storeLocation,
  }) async {
    final docStore = storeCollection.doc();
    final Store newStore = Store(
        storeOwnerId: storeOwnerId,
        storeId: docStore.id,
        storeSectors: [],
        storeName: storeName,
        storeLocation: '');
    await docStore.set(newStore.toJson());

    // update user data
    final docUser = userCollection.doc(storeOwnerId);
    await docUser.update({
      'store_id': docStore.id,
      'has_store': true,
    });
    context.read<BusinessProvider>().setStoreIdConnected(storeId: docStore.id);
  }

  void createProduct(String storeConnected, Product newProduct) async {
    print(storeConnected);
    final docStoreConnected = storeCollection.doc(storeConnected);
    await docStoreConnected
        .collection('products')
        .doc(newProduct.productName)
        .set(newProduct.toJson());
  }

  Stream<List<CustomUser>?> getUserDocs() =>
      userCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => CustomUser.fromJson(doc.data())).toList());

  // create query to get user has store proprety && dispose connectedStoreId when the user sign out
}
