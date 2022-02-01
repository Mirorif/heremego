import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heremego/pages/sign_up_page.dart';
import 'package:heremego/sevices/auth_service.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/sevices/ustils_service.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  _doSignin(){
    String email = emailController.text.toString().trim();
    String password = emailController.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;
      AuthService.signInUser(context, email, password).then((firebaseUser) => {
        print(firebaseUser),
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(User? firebaseUser) async {
    print(firebaseUser);
    if(firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.flutterToast("Check your email or password!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 45,
              color: Colors.blue,
              child: TextButton(
                onPressed: _doSignin,
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, SignUpPage.id),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
