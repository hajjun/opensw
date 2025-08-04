class Challenge {
  final String description; // Challenge 설명
  // Challenge에 필요한 아이템의 ID와 개수를 나타내는 맵
  final Map<int, int> requiredItems; // 아이템 ID와 개수

  Challenge({required this.description, required this.requiredItems});
}
