import 'package:flutter/material.dart';
import 'package:sunspark_web/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnab Admin Panel',
      home: LoginScreen(),
    );
  }
}
