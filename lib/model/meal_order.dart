class MealOrder {
  final String thumbnailUrl;
  final String menuName;
  final int price;
  final DateTime date;
  final String mealType;
  int quantity;

  MealOrder({
    required this.thumbnailUrl,
    required this.menuName,
    required this.price,
    required this.date,
    required this.mealType,
    required this.quantity,
  });

  factory MealOrder.fromJson(Map<String, dynamic> json) {
    return MealOrder(
      thumbnailUrl: json['thumbnailUrl'] as String,
      menuName: json['menuName'] as String,
      price:
          json['price'] is int
              ? json['price']
              : (json['price'] != null
                  ? int.parse(json['price'].toString())
                  : 0),
      date: DateTime.parse(json['date'] as String),
      mealType: json['mealType'] as String,
      quantity:
          json['quantity'] is int
              ? json['quantity']
              : (json['quantity'] != null
                  ? int.parse(json['quantity'].toString())
                  : 1),
    );
  }

  Map<String, dynamic> toJson() => {
    'thumbnailUrl': thumbnailUrl,
    'menuName': menuName,
    'price': price,
    'date': date.toIso8601String(),
    'mealType': mealType,
    'quantity': quantity,
  };
}
