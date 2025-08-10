// lib/models/confirmation_screen.dart
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../screens/receipt_screen.dart'; // 영수증 화면 import
import '../theme/colors.dart';

class ConfirmationScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function onOrderConfirmed;

  const ConfirmationScreen({
    super.key,
    required this.cart,
    required this.onOrderConfirmed,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  int get _totalPrice {
    return widget.cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 확인', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
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
                    backgroundColor: accentColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                  onPressed: _showPaymentDialog,
                  child: const Text('결제하기', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              leading: const Icon(Icons.credit_card),
              title: const Text('카드 결제'),
              onTap: () => _processOrder(context),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('페이 결제'),
              onTap: () => _processOrder(context),
            ),
          ],
        ),
      ),
    );
  }

  // 주문 처리 및 영수증 화면으로 이동하도록 수정
  void _processOrder(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop(); // 결제창 닫기

    Navigator.pushReplacement(
      // 현재 화면을 영수증 화면으로 교체
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          cart: widget.cart,
          totalPrice: _totalPrice,
          onConfirmed: widget.onOrderConfirmed,
        ),
      ),
    );
  }
}
