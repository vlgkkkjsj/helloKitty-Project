import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,  // ou false para desligar
      builder: (context) => const HelloKittyApp(),
    ),
  );
}

class HelloKittyApp extends StatelessWidget {
  const HelloKittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const HelloKittyHomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
      ),
    );
  }
}
