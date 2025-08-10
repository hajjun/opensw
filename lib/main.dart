import 'package:flutter/material.dart';
import 'screens/kiosk_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '테이블 오더',
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard', // 앱 전체에 적용할 폰트 (별도 설정 필요)
      ),
      home: const OrderScreen(), // 앱 실행 시 첫 화면으로 OrderScreen을 보여줍니다.
    );
  }
}
