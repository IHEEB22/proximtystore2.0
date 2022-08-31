import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proximitystore/models/custom_user.dart';
import 'package:proximitystore/utils/firebase_auth_services.dart';
import 'package:proximitystore/utils/firebase_firestore_services.dart';
import '../pages/pages.dart';

class StoreDescriptionPageWrapper extends StatefulWidget {
  const StoreDescriptionPageWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreDescriptionPageWrapper> createState() =>
      _StoreDescriptionPageWrapperState();
}

class _StoreDescriptionPageWrapperState
    extends State<StoreDescriptionPageWrapper> {
  @override
  Widget build(BuildContext context) {
    final singedInUserId = FirebaseAuthServices().getSingedInUser()!;
    print(singedInUserId);
    return Scaffold(
      body: StreamBuilder<List<CustomUser>?>(
          stream: FireStoreServices().getUserStoreId(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              CustomUser logedInUser = snapshot.data!
                  .where((user) => user.userId == singedInUserId.uid)
                  .toList()
                  .single;
              if (logedInUser.hasStore ?? false) {
                return SearchProductPage();
              } else {
                return StoreDescriptionPage();
              }
            }

            // else if (snapshot.hasError) {
            //   print('somthing went wrong' + snapshot.error.toString());
            //   return StoreDescriptionPage();
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('heyyy BNNN' + snapshot.error.toString());
              return StoreDescriptionPage();
            } else {
              return SearchProductPage();
            }
          }),
    );
  }
}
