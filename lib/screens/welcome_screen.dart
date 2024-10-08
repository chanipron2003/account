// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../main.dart'; // นำเข้า MyHomePage

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ Stack เพื่อวางภาพพื้นหลังและปุ่มบนภาพ
      body: Stack(
        children: [
          // ภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.jpg'), // ใส่ภาพพื้นหลัง (ถ้ามี)
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ปุ่ม "เริ่ม"
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('เริ่ม', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
