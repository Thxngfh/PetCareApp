import 'package:flutter/material.dart';
import 'package:pethug/screens/me.dart';

void main() {
  runApp(const MeScreen());
}

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'หน้า Me',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}