import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../Models/food.dart';
import '../Models/promo.dart';
import '../Models/user.dart';
import '../Services/shopService.dart';
import '../Services/userService.dart';

class ShopController {
  var allFoodList = <Food>[].obs;
  var allShopList = <User>[].obs;
  var allPromoList = <Promo>[].obs;
  var allShopsPromoList = <Promo>[].obs;
  var savedPromoList = <Promo>[].obs;
  var urlList = [].obs;
  var shopName = "".obs;

  void setShopName(String na) {
    shopName.value = na;
  }

  String getShopName() {
    print(shopName.value);
    return shopName.value;
  }

  ShopService shopService = ShopService();

  Future readAllFoods(String? uid) async {
    List<Food> foodList = await shopService.readAllFoods(uid!);
    allFoodList.value = foodList;
    print(allFoodList);
  }

  Future readAllPromos(String? uid) async {
    List<Promo> promoList = await shopService.readAllPromos(uid!);
    allPromoList.value = promoList;

    print(allPromoList);
  }

  Future readAllShopPromos(String? uid) async {
    List<Promo> promoList = await shopService.readAllShopPromos(uid!);
    allShopsPromoList.value = promoList;

    print(allShopsPromoList);
  }

  Future readSavedPromos(String? uid) async {
    List<Promo> promoList = await shopService.readSavedPromos(uid!);
    savedPromoList.value = promoList;

    print(savedPromoList);
  }

  clearShopList() {
    allShopList.value = [];
  }

  clearFoodList() {
    allFoodList.value = [];
  }

  Future readShops(String? uid) async {
    var shopList1 = <User>[];
    var shopList2 = <User>[];
    allShopList.value = await shopService.readShopNames(uid!);
    await 2000.milliseconds.delay();
    print(allShopList);
    allShopList.forEach((shop) {
      if (shop.pinned == "True") {
        shopList1.add(shop);
      } else {
        shopList2.add(shop);
      }
    });

    allShopList.value = shopList1 + shopList2;
  }

  Future writeNewDoc(String uid, String foodName, String price, String? url,
      String? location, String? shopName) async {
    ShopService shopService = ShopService();
    await shopService.writeNewDoc(
        uid, foodName, price, url, location, shopName);
  }

  Future addDocPromo(
      String uid, String promoDes, String date, String shopName) async {
    ShopService shopService = ShopService();
    await shopService.addDocPromo(uid, promoDes, date, shopName);
  }

  Future updateDoc(String uid, String id, String foodName, String price) async {
    await shopService.updateDoc(uid, id, foodName, price);
  }

  Future updateDocPromo(
      String uid, String id, String promoDes, String date) async {
    await shopService.updateDocPromo(uid, id, promoDes, date);
  }

  Future addDocPromotoSaved(String uid, String id, String promoDes, String date,
      String shopName) async {
    await shopService.addDocPromotoSaved(uid, id, promoDes, date, shopName);
  }

  Future addtoPinned(String uid, String id, String name) async {
    await shopService.addtoPinned(uid, id, name);
  }

  Future deleteDoc(String uid, String id, String url) async {
    await shopService.deleteDoc(uid, id, url);
  }

  Future deleteSaved(String uid, String id) async {
    await shopService.deleteSaved(uid, id);
  }

  Future deletePinned(String uid, String id) async {
    await shopService.deletePinned(uid, id);
  }

  Future deleteDocPromo(String uid, String id) async {
    await shopService.deleteDocPromo(uid, id);
  }
}
