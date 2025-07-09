class MenuItem {
  final String name; // 메뉴 이름
  final int price; // 메뉴 가격
  final String imagePath; // 메뉴 이미지 파일 경로

  // 생성자: MenuItem 객체를 만들 때 이름, 가격, 이미지 경로를 필수로 받습니다.
  MenuItem({required this.name, required this.price, required this.imagePath});
}
