import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HelloKittyApp());
}

class HelloKittyApp extends StatelessWidget {
  const HelloKittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HelloKittyHomePage(),
    );
  }
}
