import 'package:flutter/material.dart';
import 'screens/loading_screen.dart'; 

void main() {
  runApp(const PetHugApp());
}

class PetHugApp extends StatelessWidget {
  const PetHugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Hug',
      theme: ThemeData(
        fontFamily: 'Fredoka',
      ),
      home: const LoadingScreen(), // เรียกใช้ LoadingScreen เป็นหน้าแรก
    );
  }
}