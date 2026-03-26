import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:pethug/screens/loading_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "1462206525624291",
      cookie: true,
      xfbml: true,
      version: "v19.0",
    );
  }
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