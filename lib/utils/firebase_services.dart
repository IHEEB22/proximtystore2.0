import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proximitystore/models/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proximitystore/config/colors/app_colors.dart';
import 'package:proximitystore/config/routes/routes.dart';

class FirebaseServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage = '';

    try {
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(
        'user' + email.trim() + '  ' + password.trim(),
      );
      Navigator.pushNamed(context, AppRoutes.storeDescriptionPage);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
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

  Future signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage = '';

    try {
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(
        'user' + email.trim() + '  ' + password.trim(),
      );

      final docUser = FirebaseFirestore.instance.collection('users').doc();
      final CustomUser registredUser = CustomUser(
          userId: docUser.id.toString(),
          email: email,
          password: password,
          timeStamp: DateTime.now());
      await docUser.set(registredUser.toJson());
      Navigator.pushNamed(context, AppRoutes.loginPage);
    } on FirebaseAuthException catch (error) {
      switch (error.message) {
        case "The email address is already in use by another account":
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
    await auth.signOut();
  }

  Stream<User?> getCurrentUser() {
    return auth.authStateChanges();
  }
}
