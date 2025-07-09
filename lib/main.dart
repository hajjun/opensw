import 'package:flutter/material.dart';
import 'screens/kiosk_screen.dart'; // 우리가 만든 KioskScreen을 가져옵니다.

void main() {
  // 앱을 실행하는 메인 함수
  runApp(const MyApp());
}

// MyApp 클래스: 앱의 최상위 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: 구글 머티리얼 디자인을 사용하는 앱을 만들기 위한 핵심 위젯
    return MaterialApp(
      title: '키오스크 연습 앱',
      debugShowCheckedModeBanner: false, // 오른쪽 상단의 'debug' 배너 숨기기
      theme: ThemeData(
        // 앱의 전반적인 색상 테마 설정
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: 앱이 실행될 때 가장 먼저 보여줄 화면을 지정합니다.
      home: const KioskScreen(),
    );
  }
}
