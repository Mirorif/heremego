import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/pages/sign_in_page.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/sevices/ustils_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = _auth.currentUser!;
      print(user.toString());
      return user;
    } catch (e, s) {
      Utils.flutterToast("Check your information!!!");
      return null;
    }
    return null;
  }

  static Future<User?> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = _authResult.user;
      print(user.toString());
      return user;
    } catch (e, s) {
      print("${e}, $s");
      return null;
    }
    return null;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then(
        (value) => Navigator.pushReplacementNamed(context, SignInPage.id));
  }

}
