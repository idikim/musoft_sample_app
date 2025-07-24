class MealOrder {
  final String thumbnailUrl;
  final String menuName;
  final int price;
  final DateTime date;
  final String mealType;

  MealOrder({
    required this.thumbnailUrl,
    required this.menuName,
    required this.price,
    required this.date,
    required this.mealType,
  });

  factory MealOrder.fromJson(Map<String, dynamic> json) {
    return MealOrder(
      thumbnailUrl: json['thumbnailUrl'] as String,
      menuName: json['menuName'] as String,
      price:
          json['price'] is int
              ? json['price']
              : int.parse(json['price'].toString()),
      date: DateTime.parse(json['date'] as String),
      mealType: json['mealType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'thumbnailUrl': thumbnailUrl,
    'menuName': menuName,
    'price': price,
    'date': date.toIso8601String(),
    'mealType': mealType,
  };
}
