import 'dart:core';

final List<FoodCategory> foodCategories = [
  FoodCategory(kor: "한식", eng: "KOREA"),
  FoodCategory(kor: "치킨", eng: "CHICKEN"),
  FoodCategory(kor: "분식", eng: "BOONSIK"),
  FoodCategory(kor: "중식", eng: "CHINA"),
  FoodCategory(kor: "찜/탕", eng: "STEAM_AND_SOUP"),
  FoodCategory(kor: "피자", eng: "PIZZA"),
  FoodCategory(kor: "일식", eng: "JAPAN"),
  FoodCategory(kor: "패스트푸드", eng: "FASTFOOD"),
  FoodCategory(kor: "야식", eng: "LATE_NIGHT"),
  FoodCategory(kor: "도시락", eng: "LUNCHBOX"),
  FoodCategory(kor: "디저트", eng: "DESERT"),
];

class FoodCategory {
  final String kor;
  final String eng;

  FoodCategory({required this.kor, required this.eng});
}

const List<String> postCategories = [
  "전체",
  "동네질문",
  "동네맛집",
  "동네소식",
  "취미생활",
  "분실/실종",
  "품앗이",
  "기타",
];

const List<String> reportCategories = [
  "돈을 지불하지 않았어요",
  "욕설을 해요",
  "성희롱을 해요",
  "시간 약속을 안 지켜요",
  "비매너 행동을 했어요",
  "주문을 제대로 진행하지 않았어요",
  "연락이 두절됐어요",
];
