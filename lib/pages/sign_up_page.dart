import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heremego/pages/home_page.dart';
import 'package:heremego/pages/sign_in_page.dart';
import 'package:heremego/sevices/auth_service.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/sevices/ustils_service.dart';


class SignUpPage extends StatefulWidget {
  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  _doSignup(){
    String name = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = emailController.text.toString().trim();
    if(name.isEmpty || email.isEmpty || password.isEmpty) return;
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });

  }

  _getFirebaseUser(User? firebaseUser)async{
    if(firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.flutterToast("Check your informations!!!");
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
              controller: fullNameController,
              decoration: const InputDecoration(
                hintText: "Full Name",
              ),
            ),
            const SizedBox(height: 10),
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
                onPressed: _doSignup,
                child: const Text(
                  "Sign up",
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
                      Navigator.pushReplacementNamed(context, SignInPage.id),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sign in",
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
