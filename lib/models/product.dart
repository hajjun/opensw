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
