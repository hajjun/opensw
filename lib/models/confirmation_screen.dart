import 'package:flutter/material.dart';
import 'cart.dart';

class ConfirmationScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function onOrderConfirmed; // 주문 확정 시 호출될 콜백 함수

  const ConfirmationScreen({
    super.key,
    required this.cart,
    required this.onOrderConfirmed,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  // 총액 계산
  int get _totalPrice {
    return widget.cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 확인'),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: Column(
        children: [
          // 주문 목록
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return ListTile(
                  leading: Image.asset(
                    item.product.imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.product.description),
                  trailing: Text(
                    '${item.quantity}개  ${item.totalPrice}원',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, thickness: 2),
          // 최종 결제 정보 및 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 주문금액: $_totalPrice원',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                  onPressed: _showPaymentDialog, // 결제창 띄우기
                  child: const Text('결제하기', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 결제 방식 선택 다이얼로그
  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('결제 수단 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('카드 결제'),
              onTap: () => _processOrder(context),
            ),
            ListTile(
              title: const Text('페이 결제'),
              onTap: () => _processOrder(context),
            ),
          ],
        ),
      ),
    );
  }

  // 주문 처리 및 완료창 표시
  void _processOrder(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop(); // 결제창 닫기
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('주문 완료'),
        content: const Text('주문이 성공적으로 완료되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              // 1. 주문 완료창 닫기
              Navigator.of(context).pop();
              // 2. 주문 확인 화면 닫고 메인 화면으로 돌아가기
              Navigator.of(context).pop();
              // 3. 메인 화면의 장바구니 비우기 (콜백 함수 호출)
              widget.onOrderConfirmed();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
