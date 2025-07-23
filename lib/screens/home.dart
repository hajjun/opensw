import 'package:flutter/material.dart';
import 'kiosk_screen.dart';

// 앱의 작동 모드를 정의하는 열거형(Enum)
enum KioskMode { practice, challenge }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('키오스크 연습 앱'),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 연습 모드 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(250, 80),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('연습 모드'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // 연습 모드로 OrderScreen을 엽니다.
                    builder: (context) =>
                        const OrderScreen(mode: KioskMode.practice),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // 실전 문제 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(250, 80),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('실전 문제'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // 실전 문제 모드로 OrderScreen을 엽니다.
                    builder: (context) =>
                        const OrderScreen(mode: KioskMode.challenge),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
