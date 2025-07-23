import 'dart:math';
import 'package:flutter/material.dart';
// 요청하신 대로 파일 경로는 그대로 유지합니다.
import '../models/cart.dart';
import '../models/challenge.dart';
import '../models/product.dart';
import '../models/confirmation_screen.dart';
import 'home.dart';
import '../theme/colors.dart';

class OrderScreen extends StatefulWidget {
  final KioskMode mode;
  const OrderScreen({super.key, required this.mode});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // --- 데이터 정의 ---
  final List<Map<String, dynamic>> _categories = [
    {'id': 0, 'name': '전체 메뉴'},
    {'id': 1, 'name': '세트메뉴'},
    {'id': 2, 'name': '스테이크/그릴'},
    {'id': 3, 'name': '파스타&라이스'},
    {'id': 4, 'name': '피자'},
    {'id': 5, 'name': '샐러드&사이드'},
    {'id': 6, 'name': '음료'},
  ];
  final List<Product> _allProducts = [
    Product(
      id: 1,
      categoryId: 1,
      name: 'BBQ리코타 2~3인 세트',
      description: '바비큐 플래터와 리코타 샐러드',
      price: 65000,
      imagePath: 'assets/images/set_bbq.png',
    ),
    Product(
      id: 2,
      categoryId: 1,
      name: '안심 스테이크 2인 세트',
      description: '최고급 안심과 파스타',
      price: 54000,
      imagePath: 'assets/images/set_steak.png',
    ),
    Product(
      id: 3,
      categoryId: 1,
      name: '바비큐 폭립 피자 파티',
      description: '폭립, 피자, 감자튀김 구성',
      price: 80000,
      imagePath: 'assets/images/set_pizza.png',
    ),
    Product(
      id: 4,
      categoryId: 2,
      name: '립아이 스테이크',
      description: '육즙 가득한 등심 스테이크',
      price: 32000,
      imagePath: 'assets/images/steak_ribeye.png',
    ),
    Product(
      id: 5,
      categoryId: 2,
      name: '안심 스테이크',
      description: '부드러운 안심 스테이크',
      price: 35000,
      imagePath: 'assets/images/steak_tenderloin.png',
    ),
    Product(
      id: 6,
      categoryId: 2,
      name: '치킨 스테이크',
      description: '담백한 닭가슴살 스테이크',
      price: 28000,
      imagePath: 'assets/images/steak_chicken.png',
    ),
    Product(
      id: 7,
      categoryId: 3,
      name: '까르보나라',
      description: '베이컨과 크림소스의 조화',
      price: 18000,
      imagePath: 'assets/images/pasta_carbonara.png',
    ),
    Product(
      id: 8,
      categoryId: 3,
      name: '새우 필라프',
      description: '통통한 새우가 들어간 볶음밥',
      price: 19000,
      imagePath: 'assets/images/rice_pilaf.png',
    ),
    Product(
      id: 9,
      categoryId: 3,
      name: '토마토 해산물 파스타',
      description: '신선한 해산물이 가득',
      price: 21000,
      imagePath: 'assets/images/pasta_seafood.png',
    ),
    Product(
      id: 10,
      categoryId: 4,
      name: '마르게리타 피자',
      description: '토마토와 바질, 모짜렐라 치즈',
      price: 22000,
      imagePath: 'assets/images/pizza_margherita.png',
    ),
    Product(
      id: 11,
      categoryId: 4,
      name: '고르곤졸라 피자',
      description: '꿀에 찍어먹는 치즈 피자',
      price: 24000,
      imagePath: 'assets/images/pizza_gorgonzola.png',
    ),
    Product(
      id: 12,
      categoryId: 4,
      name: '페퍼로니 피자',
      description: '짭짤한 페퍼로니가 듬뿍',
      price: 23000,
      imagePath: 'assets/images/pizza_pepperoni.png',
    ),
    Product(
      id: 13,
      categoryId: 5,
      name: '시저 샐러드',
      description: '신선한 로메인과 시저 드레싱',
      price: 12000,
      imagePath: 'assets/images/side_caesar.png',
    ),
    Product(
      id: 14,
      categoryId: 5,
      name: '감자튀김',
      description: '바삭하게 튀긴 프렌치 프라이',
      price: 6000,
      imagePath: 'assets/images/side_fries.png',
    ),
    Product(
      id: 15,
      categoryId: 5,
      name: '치킨 텐더',
      description: '부드러운 닭 안심살 튀김',
      price: 8000,
      imagePath: 'assets/images/side_tender.png',
    ),
    Product(
      id: 16,
      categoryId: 5,
      name: '마늘빵',
      description: '따뜻하고 향긋한 갈릭 브레드',
      price: 4000,
      imagePath: 'assets/images/side_garlic_bread.png',
    ),
    Product(
      id: 17,
      categoryId: 6,
      name: '콜라',
      description: '시원한 탄산음료',
      price: 3000,
      imagePath: 'assets/images/drink_coke.png',
    ),
    Product(
      id: 18,
      categoryId: 6,
      name: '오렌지 주스',
      description: '신선한 오렌지 착즙 주스',
      price: 5000,
      imagePath: 'assets/images/drink_juice.png',
    ),
    Product(
      id: 19,
      categoryId: 6,
      name: '하우스 와인 (레드)',
      description: '식사와 어울리는 레드 와인 한 잔',
      price: 8000,
      imagePath: 'assets/images/drink_wine.png',
    ),
    Product(
      id: 20,
      categoryId: 6,
      name: '생수',
      description: '깨끗한 미네랄 워터',
      price: 1000,
      imagePath: 'assets/images/drink_water.png',
    ),
  ];

  // --- 상태 변수 ---
  final List<CartItem> _cart = [];
  int _selectedCategoryId = 0;
  List<Product> _displayedProducts = [];
  String _guideMessage = '';
  Challenge? _currentChallenge;
  int _practiceStep = 0;
  final List<String> _practiceGuides = [
    "먼저, 왼쪽에서 원하시는 '카테고리'를 선택해보세요.",
    "좋아요! 이제 화면에 보이는 '메뉴'를 눌러 장바구니에 담아보세요.",
    "메뉴를 담으셨군요! 우측 장바구니에서 '주문하기' 버튼을 눌러 주문을 완료할 수 있습니다.",
    "모든 연습이 끝났습니다. 실제 키오스크에서도 자신감을 가지세요!",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.mode == KioskMode.practice) {
      _practiceStep = 0;
      _guideMessage = _practiceGuides[_practiceStep];
    } else {
      _currentChallenge = _generateRandomChallenge();
    }
    _updateDisplayedProducts();
  }

  // --- 로직 함수 ---
  Challenge _generateRandomChallenge() {
    final random = Random();
    int itemCount = random.nextInt(2) + 2;
    Map<int, int> requiredItems = {};
    String description = "미션: ";
    List<Product> shuffledProducts = List.from(_allProducts)..shuffle();
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
      if (_selectedCategoryId == 0) {
        _displayedProducts = _allProducts;
      } else {
        _displayedProducts = _allProducts
            .where((p) => p.categoryId == _selectedCategoryId)
            .toList();
      }
    });
  }

  void _addToCart(Product product) {
    setState(() {
      if (widget.mode == KioskMode.practice && _practiceStep == 1) {
        _practiceStep++;
        _guideMessage = _practiceGuides[_practiceStep];
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
      if (cartItem.quantity <= 0) {
        _cart.remove(cartItem);
      }
    });
  }

  void _clearCart() {
    setState(() => _cart.clear());
  }

  int get _totalPrice => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  int get _totalQuantity => _cart.fold(0, (sum, item) => sum + item.quantity);

  bool _validateChallenge() {
    if (_currentChallenge == null) return false;
    if (_cart.length != _currentChallenge!.requiredItems.length) return false;
    for (var cartItem in _cart) {
      int productId = cartItem.product.id;
      if (!_currentChallenge!.requiredItems.containsKey(productId) ||
          _currentChallenge!.requiredItems[productId] != cartItem.quantity) {
        return false;
      }
    }
    return true;
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmationScreen(cart: _cart, onOrderConfirmed: _clearCart),
      ),
    );
  }

  // --- UI 구현 ---
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
              Expanded(flex: 2, child: _buildCartPanel()),
            ],
          ),
          _buildTopBanner(),
        ],
      ),
    );
  }

  // ▼▼▼ 지금부터 나오는 모든 _build... 함수들은 _OrderScreenState 클래스 내부에 있어야 합니다. ▼▼▼

  Widget _buildTopBanner() {
    String bannerText = '';
    if (widget.mode == KioskMode.practice) {
      bannerText = _guideMessage;
    } else if (_currentChallenge != null) {
      bannerText = _currentChallenge!.description;
    }
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        color: primaryColor.withAlpha(204), // withOpacity 대신 withAlpha 사용
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
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category['id'] == _selectedCategoryId;
                return Material(
                  color: isSelected
                      ? accentColor.withAlpha(26)
                      : Colors.transparent, // withOpacity 수정
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category['id'];
                        _updateDisplayedProducts();
                        if (widget.mode == KioskMode.practice &&
                            _practiceStep == 0) {
                          _practiceStep++;
                          _guideMessage = _practiceGuides[_practiceStep];
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

  Widget _buildCartPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '장바구니 (${_totalQuantity}개)',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            child: _cart.isEmpty
                ? const Center(
                    child: Text(
                      '장바구니가 비어있습니다.',
                      style: TextStyle(color: subTextColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = _cart[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.asset(
                            cartItem.product.imagePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.error_outline),
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
                              onPressed: () => _updateCartItem(cartItem, -1),
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
                              onPressed: () => _updateCartItem(cartItem, 1),
                            ),
                          ],
                        ),
                      );
                    },
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
                      '$_totalPrice원',
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
                    onPressed: _cart.isEmpty
                        ? null
                        : () {
                            if (widget.mode == KioskMode.challenge) {
                              if (_validateChallenge()) {
                                _navigateToConfirmation();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('미션 실패'),
                                    content: const Text(
                                      '주문 내역이 미션과 일치하지 않습니다. 장바구니를 다시 확인해주세요.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('확인'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              if (_practiceStep == 2) {
                                _practiceStep++;
                                _guideMessage = _practiceGuides[_practiceStep];
                              }
                              _navigateToConfirmation();
                            }
                          },
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
} // <--- 이 괄호가 _OrderScreenState 클래스의 끝입니다. 모든 _build 함수가 이 안에 있습니다.
