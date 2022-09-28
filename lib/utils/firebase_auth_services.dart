import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:proximitystore/models/custom_user.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proximitystore/config/colors/app_colors.dart';
import 'package:proximitystore/config/routes/routes.dart';
import 'package:proximitystore/utils/firebase_firestore_services.dart';

import '../providers/authentification_provider.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// CustomUser _userFromFirebaseUser(FirebaseUser user){
//   return
// }
  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage = '';

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(
        'user' + email.trim() + '  ' + password.trim(),
      );
      Navigator.pushNamed(context, AppRoutes.loginPageWrapper);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "invalidEmail".tr();
          break;
        case "wrong-password":
          errorMessage = "wrongPassword".tr();
          break;
        case "user-not-found":
          errorMessage = "UserNotFound".tr();
          break;
        case "user-disabled":
          errorMessage = "UserDisabled".tr();
          break;
        case "operation-not-allowed":
          errorMessage = "operationNotAllowed".tr();
          break;
        case "too-many-requests":
          errorMessage = "tooManyRequests".tr();
          break;
        default:
          errorMessage = "defaultErrorMessageForAuth".tr();
      }
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.darkBlueColor,
          msg: errorMessage,
          gravity: ToastGravity.BOTTOM,
          fontSize: 12);
      print(errorMessage);
    }
  }

  Future signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage = '';

    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(
        'user' + email.trim() + '  ' + password.trim(),
      );
      if (newUser.user != null) {
        final CustomUser registredUser = CustomUser(
          userId: newUser.user!.uid,
          email: email,
          password: password,
          timeStamp: DateTime.now().toString(),
        );
        await FireStoreServices().createUser(newUser: registredUser);
        context.read<AuthentificationProvider>().disposeControllers();
        Navigator.pushNamed(context, AppRoutes.loginPage);
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          errorMessage =
              "The email address is already in use by another account";
          break;
        default:
          errorMessage = "Sorry , Somthing wont wrong";
      }
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.darkBlueColor,
          msg: errorMessage,
          gravity: ToastGravity.BOTTOM,
          fontSize: 12);
      print(errorMessage);
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Stream<User?> getCurrentUserState() {
    return _auth.authStateChanges();
  }

  User? currentUser() {
    return _auth.currentUser;
  }

  // also create a popup (on the verivy email page)to enter the verification code (resendcode button)

//   Future requestResetPassword(String email) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }

//  Future <bool> checkRequestcode(String code) async {
//     try {
//       await _auth.checkActionCode(code);
//       await _auth.applyActionCode(code);
//       return true;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-action-code') {
//         print('The code is invalid.');
//       }
//       return false;
//     }
//   }
}
