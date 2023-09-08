import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/food.dart';
import '../Models/user.dart';

class UserService {
  var userRef = FirebaseFirestore.instance.collection('User');

//add a user
  Future writeNewDoc(String uid, String email, String name, String country,
      String catergory) async {
    var docRef = userRef.doc(uid);
    //? Create document by auto generated ID
    docRef
        .set({
          'id': uid,
          'email': email,
          'name': name,
          'country': country,
          'catergory': catergory,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//update a user
  Future updateUser(String uid, String country, String name) async {
    userRef
        .doc(uid)
        .update({'country': country, 'name': name})
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

//read all users
  Future<List<User>> readAllUsers() async {
    List<User> userList = [];
    QuerySnapshot querySnapshot = await userRef.get();

    querySnapshot.docs.forEach((doc) {});
    return userList;
  }

//get a user using id
  Future<User?> getUserByID(String userID) async {
    User? usr;
    await userRef
        .doc(userID) //Get Document By ID
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('Document does not exists on the database');
      } else {
        usr = User(
          id: documentSnapshot.get("id"),
          name: documentSnapshot.get("name"),
          email: documentSnapshot.get("email"),
          country: documentSnapshot.get("country"),
          catergory: documentSnapshot.get("catergory"),
        );
      }
    });
    return usr;
  }

//add favourite shop to foodhunt
  Future writeFavShops(String uid, String shopName) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('FavShops')
        .doc();

    await document.set({
      'id': document.id,
      'name': shopName,
    });
  }

//add favourite food to foodhunt
  Future writeFavFoods(String uid, String foodName) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('FavFoods')
        .doc();

    await document.set({
      'id': document.id,
      'foodName': foodName,
    });
  }

  //read favorite shops in foodhunt
  Future<List<User>> readFavShops(String uid) async {
    List<User> favShopList = [];
    final databaseReference = FirebaseFirestore.instance;
    var query = await databaseReference
        .collection('User')
        .doc(uid)
        .collection('FavShops')
        .get();
    query.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      User userrM = User.fromJson(data);
      favShopList.add(userrM);
    });
    return favShopList;
  }

//read favoutite foods in foodhunt
  Future<List<Food>> readFavFoods(String uid) async {
    List<Food> favShopList = [];
    final databaseReference = FirebaseFirestore.instance;
    var query = await databaseReference
        .collection('User')
        .doc(uid)
        .collection('FavFoods')
        .get();
    query.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      Food foodrM = Food.fromJson(data);
      favShopList.add(foodrM);
    });

    return favShopList;
  }

//delete a favourite shop in foodhunt
  Future deleteFavShop(String uid, String id) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('FavShops').doc(id).delete();
  }

//delete a favourite food in foodhunt
  Future deleteFavFood(String uid, String id) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('FavFoods').doc(id).delete();
  }
}
