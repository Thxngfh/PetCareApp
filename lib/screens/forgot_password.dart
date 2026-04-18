import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //  เพิ่ม import Firebase

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; //  เพิ่มตัวแปรเช็คสถานะการโหลด

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 🌟 ฟังก์ชันส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมล
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    // เช็คว่ากรอกอีเมลหรือยัง
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // เริ่มหมุนโหลด
    });

    try {
      // สั่ง Firebase ส่งอีเมลรีเซ็ตรหัสผ่าน
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      if (mounted) {
        // แจ้งเตือนเมื่อส่งสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent! Please check your email.'),
            backgroundColor: Colors.green,
          ),
        );
        // เด้งกลับไปหน้า Login อัตโนมัติ
        Navigator.pop(context);
      }
    } catch (e) {
      // ดักจับ Error แจ้งเตือนผู้ใช้
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // หยุดหมุนโหลด
        });
      }
    }
  }

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
                  //  ปิดการกดปุ่มถ้าระบบกำลังโหลดอยู่ ถ้าไม่ได้โหลดให้เรียก _resetPassword
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8CBD6),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  //  เปลี่ยนข้อความเป็นปุ่มหมุนๆ ตอนกำลังโหลด
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFF3B5998),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
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