import 'package:flutter/material.dart';
import '../models/menu_item.dart'; // 방금 만든 MenuItem 클래스를 가져옵니다.

// StatefulWidget: 화면의 상태(예: 장바구니)가 바뀔 수 있으므로 StatefulWidget으로 생성합니다.
class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  // --- 상태 변수 정의 ---

  // 키오스크에 표시될 메뉴 목록 (실제 앱에서는 서버나 DB에서 가져올 수 있습니다)
  final List<MenuItem> _menuItems = [
    MenuItem(
      name: "아메리카노",
      price: 4500,
      imagePath: "assets/images/americano.png",
    ),
    MenuItem(name: "카페라떼", price: 5000, imagePath: "assets/images/latte.png"),
    // 여기에 메뉴를 더 추가할 수 있습니다.
  ];

  // 장바구니 역할을 할 리스트. 처음에는 비어있습니다.
  final List<MenuItem> _shoppingCart = [];

  // --- 헬퍼 함수 정의 ---

  // 장바구니의 총 금액을 계산하는 함수
  int _calculateTotalPrice() {
    int totalPrice = 0;
    for (var item in _shoppingCart) {
      totalPrice += item.price;
    }
    return totalPrice;
  }

  // --- UI 구현 ---

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱 화면의 기본적인 구조를 제공하는 위젯
    return Scaffold(
      // AppBar: 화면 상단의 제목 바
      appBar: AppBar(
        title: const Text('키오스크 TEST'),
        backgroundColor: Colors.brown,
      ),
      // body: 화면의 주요 콘텐츠 영역
      body: Column(
        children: [
          // Expanded: 남은 공간을 모두 차지하도록 메뉴판 영역을 확장합니다.
          Expanded(
            // GridView.builder: 격자 형태의 메뉴판을 효율적으로 만듭니다.
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              // 그리드의 모양을 정의합니다. 한 줄에 2개의 아이템을 표시합니다.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              // 메뉴 아이템의 개수만큼 그리드를 생성합니다.
              itemCount: _menuItems.length,
              // 각 그리드 셀에 들어갈 위젯을 정의합니다.
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                // InkWell: Card에 클릭 이벤트를 주기 위해 감싸는 위젯
                return InkWell(
                  // 탭했을 때의 동작 정의
                  onTap: () {
                    // setState: 상태가 변경되었음을 알려 화면을 다시 그리게 합니다.
                    setState(() {
                      _shoppingCart.add(item); // 장바구니에 아이템 추가
                    });
                  },
                  // Card: 입체감 있는 UI를 위한 위젯
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.antiAlias, // 이미지가 Card의 둥근 모서리를 넘지 않도록
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Expanded를 사용해 이미지가 카드의 남는 공간을 꽉 채우게 합니다.
                        Expanded(
                          child: Image.asset(item.imagePath, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item.price}원',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // --- 하단 장바구니 및 주문 버튼 영역 ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '담은 개수: ${_shoppingCart.length}개',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '총 금액: ${_calculateTotalPrice()}원',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {
                    // 주문하기 버튼을 눌렀을 때의 동작 (여기서는 간단한 대화상자 표시)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('주문 완료'),
                        content: Text(
                          '총 ${_calculateTotalPrice()}원 결제가 완료되었습니다.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 대화상자 닫기
                              setState(() {
                                _shoppingCart.clear(); // 장바구니 비우기
                              });
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('주문하기', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
