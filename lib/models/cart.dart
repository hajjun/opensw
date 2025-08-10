import '../screens/kiosk_screen.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // 총 가격 계산
  int get totalPrice => product.price * quantity;
}
