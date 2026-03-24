import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: const Color(0xFF8FE7FF),
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: const Color(0xFF8FE7FF),
        iconTheme: const IconThemeData(
        color: Color(0xFF5A7E9A), // สีลูกศรย้อนกลับ
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 18,
          color: Color(0xFF5A7E9A),
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            const Text(
              'Enter your email to reset password',
              style: TextStyle(
                fontFamily: 'Fredoka',
                color: Color(0xFF5A7E9A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 5),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email Address',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Fredoka',
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // จัดการเมื่อกดส่งรีเซ็ตรหัสผ่าน
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8CBD6),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'SEND RESET LINK',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B5998),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}