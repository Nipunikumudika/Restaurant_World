import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Models/food.dart';
import '../Models/user.dart';
import '../Services/userService.dart';

class UserController {
  var uid = "".obs;
  var shopid = "".obs;
  var cuser = User().obs;

  var favShopList = <User>[].obs;
  var favFoodList = <Food>[].obs;

  UserService userService = UserService();

  void setID(String na) {
    uid.value = na;
  }

  String getID() {
    print(uid.value);
    return uid.value;
  }

  void setCUser(User usr) {
    cuser.value = usr;
  }

  void setShopId(String id) {
    shopid.value = id;
  }

  String getShopId() {
    return shopid.value;
  }

  User getCUser() {
    return cuser.value;
  }

  Future readAllUsers() async {
    List<User> userList = await userService.readAllUsers();
  }

  Future readFavShops(String? uid) async {
    List<User> allfavShopList = await userService.readFavShops(uid!);
    favShopList.value = allfavShopList;
    print(allfavShopList);
  }

  Future readFavFoods(String? uid) async {
    List<Food> allfavFoodList = await userService.readFavFoods(uid!);
    favFoodList.value = allfavFoodList;
    print(allfavFoodList);
  }

  Future getUserByID(String? userID) async {
    User? usr = await userService.getUserByID(userID!);

    setCUser(usr!);
  }

  Future writeNewDoc(String uid, String email, String name, String country,
      String catergory) async {
    await userService.writeNewDoc(uid, email, name, country, catergory);
    User? usr = await userService.getUserByID(uid);
    setCUser(usr!);
  }

  Future writeFavShops(String uid, String shopName) async {
    await userService.writeFavShops(uid, shopName);
  }

  Future writeFavFoods(String uid, String foodName) async {
    await userService.writeFavFoods(uid, foodName);
  }

  Future updateUser(String uid, String country, String name) async {
    await userService.updateUser(uid, country, name);
  }

  Future deleteFavShop(String uid, String id) async {
    await userService.deleteFavShop(uid, id);
  }

  Future deleteFavFood(String uid, String id) async {
    await userService.deleteFavFood(uid, id);
  }
}
