// lib/screens/kiosk_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/mock_data.dart';
import '../models/cart.dart';
import '../models/challenge.dart';
import '../models/product.dart';
import '../theme/colors.dart';
import '../widgets/cart_panel.dart';
import '../models/confirmation_screen.dart';
import 'home.dart';

class OrderScreen extends StatefulWidget {
  final KioskMode mode;
  const OrderScreen({super.key, required this.mode});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final List<CartItem> _cart = [];
  int _selectedCategoryId = 0;
  List<Product> _displayedProducts = [];
  String _guideMessage = '';
  Challenge? _currentChallenge;
  int _practiceStep = 0;
  final List<String> _practiceGuides = [
    "먼저, 왼쪽에서 원하시는 '카테고리'를 선택해보세요.",
    "좋아요! 원하는 만큼 메뉴를 담고 '주문하기'를 눌러보세요.",
    "모든 연습이 끝났습니다. 실제 키오스크에서도 자신감을 가지세요!",
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    if (widget.mode == KioskMode.practice) {
      _practiceStep = 0;
      _guideMessage = _practiceGuides[_practiceStep];
      _speak(_guideMessage);
    } else {
      _currentChallenge = _generateRandomChallenge();
      if (_currentChallenge != null) _speak(_currentChallenge!.description);
    }
    _updateDisplayedProducts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Challenge _generateRandomChallenge() {
    final random = Random();
    int itemCount = random.nextInt(2) + 2;
    Map<int, int> requiredItems = {};
    String description = "미션: ";
    List<Product> shuffledProducts = List.from(mockProducts)..shuffle();
    for (int i = 0; i < itemCount; i++) {
      Product product = shuffledProducts[i];
      int quantity = random.nextInt(2) + 1;
      requiredItems[product.id] = quantity;
      description += "${product.name} ${quantity}개";
      if (i < itemCount - 1) {
        description += ", ";
      }
    }
    description += "를 주문하세요.";
    return Challenge(description: description, requiredItems: requiredItems);
  }

  void _updateDisplayedProducts() {
    setState(() {
      if (_selectedCategoryId == 0)
        _displayedProducts = mockProducts;
      else
        _displayedProducts = mockProducts
            .where((p) => p.categoryId == _selectedCategoryId)
            .toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _speak("${product.name}을 장바구니에 담았습니다.");
      if (widget.mode == KioskMode.practice && _practiceStep == 0) {
        _practiceStep++;
        _guideMessage = _practiceGuides[_practiceStep];
        _speak(_guideMessage);
      }
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
      if (cartItem.quantity <= 0) _cart.remove(cartItem);
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      _speak("장바구니를 모두 비웠습니다.");
    });
  }

  String _validateChallenge() {
    if (_currentChallenge == null) return "문제가 설정되지 않았습니다.";
    if (_cart.length != _currentChallenge!.requiredItems.length)
      return "주문하신 메뉴의 종류가 미션과 다릅니다.";

    for (var cartItem in _cart) {
      int productId = cartItem.product.id;
      if (!_currentChallenge!.requiredItems.containsKey(productId))
        return "${cartItem.product.name}은(는) 미션에 없는 메뉴입니다.";
      if (_currentChallenge!.requiredItems[productId] != cartItem.quantity)
        return "${cartItem.product.name}의 수량이 미션과 다릅니다.";
    }
    return "";
  }

  void _processCheckout() {
    if (widget.mode == KioskMode.challenge) {
      String validationResult = _validateChallenge();
      if (validationResult.isEmpty) {
        _speak("미션 성공! 주문을 확인해주세요.");
        _navigateToConfirmation();
      } else {
        _speak("미션 실패. $validationResult");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('미션 실패'),
            content: Text(validationResult),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } else {
      _speak("주문 내용을 확인해주세요.");
      _navigateToConfirmation();
    }
  }

  void _navigateToConfirmation() {
    if (widget.mode == KioskMode.practice) {
      _practiceStep++;
      if (_practiceStep < _practiceGuides.length)
        _guideMessage = _practiceGuides[_practiceStep];
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmationScreen(cart: _cart, onOrderConfirmed: _clearCart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.mode == KioskMode.practice ? '연습 모드' : '실전 문제',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
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
                  onCheckout: _processCheckout,
                ),
              ),
            ],
          ),
          _buildTopBanner(),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    String bannerText = '';
    if (widget.mode == KioskMode.practice)
      bannerText = _guideMessage;
    else if (_currentChallenge != null)
      bannerText = _currentChallenge!.description;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        color: primaryColor.withAlpha(204),
        child: Text(
          bannerText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Container(
      width: 160,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final isSelected = category['id'] == _selectedCategoryId;
                return Material(
                  color: isSelected
                      ? accentColor.withAlpha(26)
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _speak("${category['name']} 카테고리를 선택했습니다.");
                      setState(() {
                        _selectedCategoryId = category['id'];
                        _updateDisplayedProducts();
                        if (widget.mode == KioskMode.practice &&
                            _practiceStep == 0) {
                          _practiceStep++;
                          _guideMessage = _practiceGuides[_practiceStep];
                          _speak(_guideMessage);
                        }
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
                            color: isSelected
                                ? accentColor
                                : Colors.transparent,
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
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
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
      ),
    );
  }
}
