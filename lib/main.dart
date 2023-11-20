import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';

void main() {
  runApp(MaterialApp(
    title: 'Ain_shams Car pooling',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: SignInPage(),
  ));
}