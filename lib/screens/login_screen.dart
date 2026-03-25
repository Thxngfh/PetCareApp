import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
import 'forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';// import package สำหรับใช้งาน Firebase Authentication
import 'package:google_sign_in/google_sign_in.dart';// import package สำหรับ login ผ่าน Google
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // ใช้ Facebook login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// --------------------------google sign in function-------------------------
    
    // เปิดหน้าต่างให้ผู้ใช้เลือกบัญชี Google
    Future<UserCredential> signInWithGoogle() async {
  final provider = GoogleAuthProvider();
  return await FirebaseAuth.instance.signInWithPopup(provider);
}

// --------------------------facebook sign in function--------------------------
// ฟังก์ชัน Login Facebook
Future<UserCredential> signInWithFacebook() async {
  final provider = FacebookAuthProvider();
  return await FirebaseAuth.instance.signInWithPopup(provider);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FE7FF), 
      body: SafeArea(
        child: SingleChildScrollView( // ป้องกันปัญหาคีย์บอร์ดบังหน้าจอ
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Email',
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
                  hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Fredoka'),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, 
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ช่องกรอก Password
              const Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  color: Color(0xFF5A7E9A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true, // ซ่อนตัวอักษรเวลาพิมพ์รหัส
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Fredoka'),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // ปุ่ม Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // จัดการลืมรหัสผ่าน
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                  },
                  child: const Text(
                    'Forgot Your Password?',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFF5A7E9A),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ปุ่ม LOGIN หลัก
              Center(
                child: SizedBox(
                  width: 150, 
                  child: ElevatedButton(
                    onPressed: () {
                      // จัดการเมื่อกด Login
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
                      'LOGIN',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B5998), 
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // เส้นแบ่ง Or Sign In With
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.blueGrey[300])),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or Sign In With',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        color: Color(0xFF5A7E9A),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.blueGrey[300])),
                ],
              ),
              const SizedBox(height: 20),

              // ปุ่ม Social Login (แยกเป็น Widget ด้านล่างเพื่อความสะอาดของโค้ด)
              _buildSocialLoginButton(
                icon: FontAwesomeIcons.google,
                text: 'Login With Google',
                onPressed: () async{
                  // เรียกใช้ฟังก์ชัน login ด้วย Google
                  await signInWithGoogle();},
              ),
              const SizedBox(height: 15),
              _buildSocialLoginButton(
                icon: FontAwesomeIcons.facebookF,
                text: 'Login With Facebook',
                onPressed: () async {
                  try {
                    await signInWithFacebook();
                  } catch (e) {
                    print("Facebook error: $e");
                  }
                },
              ),
              const SizedBox(height: 15),
              _buildSocialLoginButton(
                icon: FontAwesomeIcons.apple,
                text: 'Login With Apple',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันช่วยสร้างปุ่ม Social Login
  Widget _buildSocialLoginButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Color(0xFF3B5998), size: 20),
      label: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 16,
          color: Color(0xFF3B5998),
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF8CBD6), 
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        elevation: 0,
        alignment: Alignment.center, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}