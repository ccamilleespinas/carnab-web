import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sunspark_web/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: 'sunspark-efc9c.firebaseapp.com',
          apiKey: "AIzaSyCjBNEAEtehapPMZ6mq6Hsr6Vpu_k4xnGk",
          appId: "1:913725694142:web:831d6db71c673a20c13eef",
          messagingSenderId: "913725694142",
          projectId: "sunspark-efc9c",
          storageBucket: "sunspark-efc9c.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Carnab Admin Panel',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
