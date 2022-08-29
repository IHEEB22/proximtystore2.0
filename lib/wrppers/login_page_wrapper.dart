import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/firebase_auth_services.dart';
import '../pages/pages.dart';

class LoginPageWrapper extends StatefulWidget {
  const LoginPageWrapper({Key? key}) : super(key: key);

  @override
  State<LoginPageWrapper> createState() => _LoginPageWrapperState();
}

class _LoginPageWrapperState extends State<LoginPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuthServices().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoreDescriptionPageWrapper();
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
