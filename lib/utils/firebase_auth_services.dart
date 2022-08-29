import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:proximitystore/models/custom_user.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proximitystore/config/colors/app_colors.dart';
import 'package:proximitystore/config/routes/routes.dart';

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
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(
        'user' + email.trim() + '  ' + password.trim(),
      );
      if (newUser.user != null) {
        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.user!.uid);
        final CustomUser registredUser = CustomUser(
          userId: newUser.user!.uid,
          email: email,
          password: password,
          timeStamp: DateTime.now().toString(),
        );
        await docUser.set(registredUser.toJson());
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

  // User? getSingedInUser() => _auth.currentUser;

  Stream<User?> getCurrentUser() {
    return _auth.authStateChanges();
  }
}