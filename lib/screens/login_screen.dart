import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // google sign in function
  // เปิดหน้าต่างให้ผู้ใช้เลือกบัญชี Google
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Web
      final provider = GoogleAuthProvider();
      return await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      // Android / iOS
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception("User cancelled");
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  // facebook sign in function
  // ฟังก์ชัน Login Facebook
  Future<UserCredential> signInWithFacebook() async {
    if (kIsWeb) {
      // สำหรับรันบนเว็บ (Chrome)
      final provider = FacebookAuthProvider();
      return await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      // สำหรับมือถือ (Android/iOS)
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        // เปลี่ยนจาก tokenString เป็น token เฉยๆ
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw Exception("Facebook login failed: ${result.message}");
      }
    }
  }

  // apple sign in function
  Future<UserCredential> signInWithApple() async {
    // เปิดหน้า Login Apple
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // สร้าง credential สำหรับ Firebase
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Login Firebase
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FE7FF),
      body: SafeArea(
        child: SingleChildScrollView(
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
                obscureText: _isObscure, 
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Fredoka',
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; 
                      });
                    },
                  ),
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
                        builder: (context) => const ForgotPasswordScreen(),
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
                      final enteredEmail = _emailController.text;

                      // ส่งค่าไปทั้ง Email และบอกให้เปิดแท็บที่ 4 (หน้า Me)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            userEmail: enteredEmail,
                            initialIndex: 4, 
                          ),
                        ),
                      );
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

              // ปุ่ม Social Login
              _buildSocialLoginButton(
                icon: FontAwesomeIcons.google,
                text: 'Login With Google',
                onPressed: () async {
                  try {
                    final userCredential = await signInWithGoogle();
                    final googleEmail = userCredential.user?.email ?? '';

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            userEmail: googleEmail, 
                            initialIndex: 4, 
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    print("Google login error: $e");
                  }
                },
              ),

              const SizedBox(height: 15),

              _buildSocialLoginButton(
                icon: FontAwesomeIcons.facebookF,
                text: 'Login With Facebook',
                onPressed: () async {
                  try {
                    final userCredential = await signInWithFacebook();
                    final facebookEmail = userCredential.user?.email ?? '';

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            userEmail: facebookEmail,
                            initialIndex: 4, 
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    print("Facebook error: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เกิดข้อผิดพลาด: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),

              if (!kIsWeb && Platform.isIOS) ...[
                const SizedBox(height: 15), 
                _buildSocialLoginButton(
                  icon: FontAwesomeIcons.apple,
                  text: 'Login With Apple',
                  onPressed: () async {
                    try {
                      final userCredential = await signInWithApple();
                      final appleEmail = userCredential.user?.email ?? '';

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(
                              userEmail: appleEmail,
                              initialIndex: 4, 
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print("Apple login error: $e");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('เกิดข้อผิดพลาด: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
              
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
      icon: Icon(icon, color: const Color(0xFF3B5998), size: 20),
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