import 'package:face_attend/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  // setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login()
    );
  }
}

