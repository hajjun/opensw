class Challenge {
  final String description; // "안심 스테이크 1개, 까르보나라 2개를 주문하세요"
  final Map<int, int> requiredItems; // 정답 주문 내역 {상품ID: 수량}

  Challenge({required this.description, required this.requiredItems});
}
