import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Ain_shams Car pooling',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: SignInPage(),
  ));
}

/*@override
void initState() {
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null) {
      print('===============================User is currently signed out!');
    } else {
      print('=========================User is signed in!');
    }
  });
  super.initState();
}*/