import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
  String? foodName;
  String? price;
  String? url;
  String? id;
  String? location;
  String? shopName;

  Food({
    this.foodName,
    this.price,
    this.url,
    this.id,
    this.location,
    this.shopName,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodName: json["foodName"],
        price: json["price"],
        url: json["url"],
        id: json["id"],
        location: json["location"],
        shopName: json["shopName"],
      );

  Map<String, dynamic> toJson() => {
        "foodName": foodName,
        "price": price,
        "url": url,
        "id": id,
        "location": location,
        "shopName": shopName,
      };
}
