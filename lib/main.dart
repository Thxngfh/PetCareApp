import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:pethug/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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