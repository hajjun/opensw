// lib/screens/kiosk_screen.dart
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cart.dart';
import '../theme/colors.dart';
import '../widgets/cart_panel.dart';
import '../models/confirmation_screen.dart';

class Challenge {
  final String description; // Challenge 설명
  // Challenge에 필요한 아이템의 ID와 개수를 나타내는 맵
  final Map<int, int> requiredItems; // 아이템 ID와 개수

  Challenge({required this.description, required this.requiredItems});
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final int price;
  final String imagePath;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // --- 상태 변수 ---
  final List<CartItem> _cart = [];
  int _selectedCategoryId = 0;
  List<Product> _displayedProducts = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateDisplayedProducts(); // 앱 시작 시 전체 메뉴를 보여줍니다.
  }

  // --- 로직 함수 ---
  void _updateDisplayedProducts() {
    setState(() {
      if (_selectedCategoryId == 0) {
        _displayedProducts = mockProducts;
      } else {
        _displayedProducts = mockProducts
            .where((p) => p.categoryId == _selectedCategoryId)
            .toList();
      }
    });
  }

  void _addToCart(Product product) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // 애니메이션 효과를 위해 약간의 지연 추가

    setState(() {
      for (var item in _cart) {
        if (item.product.id == product.id) {
          item.quantity++;
          return;
        }
      }
      _cart.add(CartItem(product: product));
    });
  }

  void _updateCartItem(CartItem cartItem, int change) {
    setState(() {
      cartItem.quantity += change;
      if (cartItem.quantity <= 0) {
        _cart.remove(cartItem);
      }
    });
  }

  void _clearCart() {
    setState(() => _cart.clear());
  }

  void _navigateToConfirmation() async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    await Future.delayed(const Duration(milliseconds: 500)); // 1초 대기

    setState(() {
      _isLoading = false; // 로딩 종료
    });

    // mounted 체크
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmationScreen(cart: _cart, onOrderConfirmed: _clearCart),
      ),
    );
  }

  // [추가] 도움말 팝업창을 보여주는 함수
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('키오스크 사용법 안내'),
        content: const SingleChildScrollView(
          child: Text(
            "1. 왼쪽 '카테고리' 목록에서 원하는 메뉴 종류를 선택하세요.\n\n"
            "2. 화면에 나타난 '메뉴'를 터치하여 장바구니에 담으세요.\n\n"
            "3. 오른쪽 '장바구니'에서 담은 메뉴와 수량을 확인하세요. (+/- 버튼으로 수량 조절, 전체 비우기도 가능합니다.)\n\n"
            "4. 주문할 준비가 되면 '주문하기' 버튼을 누르세요.\n\n"
            "5. '주문 확인' 화면에서 최종 내역을 확인하고 '결제하기'를 누르면 완료됩니다.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // --- UI 구현 ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          '테이블 오더',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelpDialog,
            tooltip: '도움말 보기',
          ),
        ],
      ),
      // [수정] 기존 UI 위에 로딩 스피너를 겹쳐서 표시하기 위해 Stack 사용
      body: Stack(
        children: [
          Row(
            children: [
              _buildCategorySidebar(),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Colors.black12,
              ),
              Expanded(flex: 3, child: _buildProductGrid()),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Colors.black12,
              ),
              Expanded(
                flex: 2,
                child: CartPanel(
                  cart: _cart,
                  onUpdateItem: _updateCartItem,
                  onClearCart: _clearCart,
                  onCheckout: _navigateToConfirmation,
                ),
              ),
            ],
          ),

          // [추가] _isLoading이 true일 때만 로딩 화면을 보여줌
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Container(
      width: 160,
      color: Colors.white,
      child: ListView.builder(
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final category = mockCategories[index];
          final isSelected = category['id'] == _selectedCategoryId;
          return Material(
            color: isSelected ? accentColor.withAlpha(26) : Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategoryId = category['id'];
                  _updateDisplayedProducts();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: isSelected ? accentColor : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  category['name']!,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    // [수정] 화면 너비에 따라 한 줄에 표시할 아이템 개수를 동적으로 계산
    final screenWidth = MediaQuery.of(context).size.width;
    // 메뉴판 영역은 전체 너비의 약 50% (flex: 3), 장바구니 영역(flex: 2)을 제외한 나머지
    final gridWidth = screenWidth * 3 / 5;
    final crossAxisCount = (gridWidth / 220).floor().clamp(
      2,
      4,
    ); // 아이템 하나의 최소 너비를 220으로 가정하여 계산, 최소 2개 최대 4개

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // 동적으로 계산된 값 사용
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: _displayedProducts.length,
      itemBuilder: (context, index) {
        final product = _displayedProducts[index];
        return InkWell(
          onTap: () => _addToCart(product),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Center(
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${product.price}원',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
