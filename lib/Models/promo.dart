import 'dart:convert';

Promo PromoFromJson(String str) => Promo.fromJson(json.decode(str));

String PromoToJson(Promo data) => json.encode(data.toJson());

class Promo {
  String? id;
  String? promoDes;
  String? date;
  String? shopName;
  String? saved = "False";

  Promo({
    this.id,
    this.promoDes,
    this.date,
    this.shopName,
    this.saved,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        id: json["id"],
        promoDes: json["promoDes"],
        date: json["date"],
        shopName: json["shopName"],
        saved: json["saved"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "promoDes": promoDes,
        "date": date,
        "shopName": shopName,
        "saved": saved,
      };
}
