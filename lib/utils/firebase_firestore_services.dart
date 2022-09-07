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
      // storeLocation: ''
    );
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

  // Future<CustomUser> getSignedInUser() async {
  //   print('********************************************');

  //   return await userCollection
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => CustomUser.fromJson(doc.data()))
  //           .toList()
  //           .where((user) =>
  //               user.userId == FirebaseAuthServices().currentUser()!.uid)
  //           .toList()
  //           .single)
  //       .single;
  // }

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

  // Stream<String> getStoreIdConnected(String uid) {
  //   return userCollection.snapshots().map((snapshot) => snapshot.docs
  //       .map((doc) {
  //         if (doc.data()['user_id'].toString() == uid)
  //           print(doc.data()['user_id']);

  //         return doc.data()['store_id'].toString();
  //       })
  //       .toList()
  //       .first);
  // }

  // Stream<List<Product>> getUserProducts(String uid) {
  //   return storeCollection.where("sdsd"=='eee');
  // }

  Stream<List<Product>> getProductList(String storeId) {
    // 3andek zoz 7pulul ya t3ayet lel products collection toul walla ta3mel
    // new ceollection esmha products fkol document 3andek owner id w taksideilha toul abda bel fekra loula
    // fel get user aut raja3 CustomUser w lena aksidi lel store id
    // CustomUser signedInUser = await getSignedInUser();
    print('before stream');

    return storeCollection.doc(storeId).collection('products').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }
// }

// create query to get user has store proprety && dispose connectedStoreId when the user sign out
}
