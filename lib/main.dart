import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heremego/pages/detail_page.dart';
import 'package:heremego/pages/home_page.dart';
import 'package:heremego/pages/sign_in_page.dart';
import 'package:heremego/pages/sign_up_page.dart';
import 'package:heremego/sevices/prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:const FirebaseOptions(
    apiKey: "AIzaSyAAzpzvxt-rjLtIZjPFPgA3-C0rtMsUmHc",
    appId: "1:401010575915:android:bf109d4e1db7dae77bb86e",
    messagingSenderId: "401010575915",
    projectId: "heremego-eeaa8",
  ),);
  runApp(const MyApp());
}

class DefaultFirebaseConfig {
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData) {
          Prefs.saveUserId(snapshot.data!.uid);
          return HomePage();
        } else {
          Prefs.removeUserId();
          return SignInPage();
        }
      }
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  _startPage(),
      routes: {
        HomePage.id: (context) =>  HomePage(),
        SignInPage.id: (context) =>  SignInPage(),
        SignUpPage.id: (context) =>  SignUpPage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
