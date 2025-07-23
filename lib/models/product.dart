class Product {
  final int id;
  final int categoryId;
  final String name;
  final String description; // [1] 메뉴 설명을 담을 변수 추가
  final int price;
  final String imagePath;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description, // [2] 생성자에도 필수로 받도록 추가
    required this.price,
    required this.imagePath,
  });
}
