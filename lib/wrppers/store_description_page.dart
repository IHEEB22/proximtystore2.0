import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proximitystore/models/custom_user.dart';
import '../utils/firebase_services.dart';
import '../pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPageWrapper extends StatefulWidget {
  const LoginPageWrapper({Key? key}) : super(key: key);

  @override
  State<LoginPageWrapper> createState() => _LoginPageWrapperState();
}

class _LoginPageWrapperState extends State<LoginPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CustomUser>?>(
        stream: FirebaseFirestore.instance.collection('users').snapshots().map(
            (snapshot) => snapshot.docs
                .map((user) => CustomUser.fromJson(user.data()))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoreDescriptionPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('somthing went wrong');
            return LoginPage();
          } else {
            return LoginPage();
          }
          // add another wrapper in the commere button to go to
          // the addnewproductpage if the user is connected and the  store has created sinon hezu lel store description page
          //if he is not connected hezu lel welcome page
        },
      ),
    );
  }
}
