import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proximitystore/config/colors/app_colors.dart';
import 'package:proximitystore/wrappers/store_description_page_wrapper.dart';

import '../utils/firebase_auth_services.dart';
import '../pages/pages.dart';

class WelcomePageWrapper extends StatefulWidget {
  const WelcomePageWrapper({Key? key}) : super(key: key);

  @override
  State<WelcomePageWrapper> createState() => _WelcomePageWrapperState();
}

class _WelcomePageWrapperState extends State<WelcomePageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuthServices().getCurrentUserState(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoreDescriptionPageWrapper();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: AppColors.lightPurpleColor);
          } else if (snapshot.hasError) {
            print('somthing went wrong');
            return WelcomePage();
          } else {
            return WelcomePage();
          }
          // add another wrapper in the commere button to go to
          // the addnewproductpage if the user is connected and the  store has created sinon hezu lel store description page
          //if he is not connected hezu lel welcome page
        },
      ),
    );
  }
}
