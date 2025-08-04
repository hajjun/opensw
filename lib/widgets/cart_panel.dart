// lib/widgets/cart_panel.dart
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../theme/colors.dart';

class CartPanel extends StatelessWidget {
  final List<CartItem> cart;
  final Function(CartItem, int) onUpdateItem;
  final VoidCallback onClearCart;
  final VoidCallback onCheckout;

  const CartPanel({
    super.key,
    required this.cart,
    required this.onUpdateItem,
    required this.onClearCart,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    int totalPrice = cart.fold(0, (sum, item) => sum + item.totalPrice);
    int totalQuantity = cart.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '장바구니 ($totalQuantity개)',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: cart.isEmpty ? null : onClearCart,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('전체 비우기'),
                  style: TextButton.styleFrom(foregroundColor: subTextColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: cart.isEmpty
                  ? const Center(
                      key: ValueKey('empty'),
                      child: Text(
                        '장바구니가 비어있습니다.',
                        style: TextStyle(color: subTextColor),
                      ),
                    )
                  : ListView.builder(
                      key: const ValueKey('list'),
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final cartItem = cart[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Image.asset(
                              cartItem.product.imagePath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            cartItem.product.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            '${cartItem.product.price}원',
                            style: const TextStyle(color: subTextColor),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: () => onUpdateItem(cartItem, -1),
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: primaryColor,
                                ),
                                onPressed: () => onUpdateItem(cartItem, 1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '총 주문금액',
                      style: TextStyle(fontSize: 18, color: subTextColor),
                    ),
                    Text(
                      '$totalPrice원',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: cart.isEmpty ? null : onCheckout,
                    child: const Text('주문하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
