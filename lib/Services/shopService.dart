import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import '../Models/food.dart';
import '../Models/promo.dart';
import '../Models/user.dart';

class ShopService {
  var userRef = FirebaseFirestore.instance.collection('User');

  //create a new food
  Future writeNewDoc(String uid, String foodName, String price, String? url,
      String? location, String? shopName) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Foods')
        .doc();

    await document.set({
      'id': document.id,
      'foodName': foodName,
      'price': price,
      'url': url,
      'location': location,
      'shopName': shopName,
    });
  }

  //delete a food
  Future deleteDoc(String uid, String id, String url) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('Foods').doc(id).delete();

    Reference photoRef = await FirebaseStorage.instance.refFromURL(url);
    await photoRef.delete().then((value) {
      print('deleted Successfully');
    });
  }

//read all foods in one shop
  Future<List<Food>> readAllFoods(String uid) async {
    List<Food> foodList = [];

    final databaseReference = FirebaseFirestore.instance;
    var query = await databaseReference
        .collection('User')
        .doc(uid)
        .collection('Foods')
        .get();
    query.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      Food foodrM = Food.fromJson(data);
      foodList.add(foodrM);
    });
    return foodList;
  }

  //update foods
  Future updateDoc(String uid, String id, String foodName, String price) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef
        .collection('User')
        .doc(uid)
        .collection('Foods')
        .doc(id)
        .update({'foodName': foodName, 'price': price})
        .then((value) => print("Food updated"))
        .catchError((error) => print("Failed to update food: $error"));
  }

//create a new promo
  Future addDocPromo(
      String uid, String promoDes, String date, String shopName) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Promos')
        .doc();

    await document.set({
      'id': document.id,
      'promoDes': promoDes,
      'date': date,
      'shopName': shopName,
    });
  }

//read all promos in one shop
  Future<List<Promo>> readAllPromos(String uid) async {
    List<Promo> promoList = [];

    final databaseReference = FirebaseFirestore.instance;
    var query = await databaseReference
        .collection('User')
        .doc(uid)
        .collection('Promos')
        .get();
    query.docs.forEach((doc) async {
      Map<String, dynamic> data = doc.data();
      Promo promorM = Promo.fromJson(data);

      var shopRef = FirebaseFirestore.instance;
      shopRef
          .collection('User')
          .doc(uid)
          .collection('Saved')
          .doc(promorM.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          promorM.saved = "False";
        } else {
          promorM.saved = "True";
        }
      });
      promoList.add(promorM);
    });

    return promoList;
  }

//read the promos of all shops
  Future<List<Promo>> readAllShopPromos(String uid) async {
    List<Promo> promoList = [];
    var query = await userRef.where("catergory", isEqualTo: "shop").get();

    query.docs.forEach((doc) async {
      Promo promoM = await Promo.fromJson(doc.data());
      final databaseReference = FirebaseFirestore.instance;
      var query = await databaseReference
          .collection('User')
          .doc(doc.id)
          .collection('Promos')
          .get();
      query.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        Promo promorM = Promo.fromJson(data);

        var shopRef = FirebaseFirestore.instance;
        shopRef
            .collection('User')
            .doc(uid)
            .collection('Saved')
            .doc(promorM.id)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (!documentSnapshot.exists) {
            promorM.saved = "False";
          } else {
            promorM.saved = "True";
          }
        });

        promoList.add(promorM);
      });
    });
    return promoList;
  }

//read saved promos
  Future<List<Promo>> readSavedPromos(String uid) async {
    List<Promo> promoList = [];

    final databaseReference = FirebaseFirestore.instance;
    var query = await databaseReference
        .collection('User')
        .doc(uid)
        .collection('Saved')
        .get();
    query.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      Promo promorM = Promo.fromJson(data);
      promoList.add(promorM);
    });

    return promoList;
  }

//read all shop names
  Future<List<User>> readShopNames(String uid) async {
    List<User> shopList = [];

    var query = await userRef.where("catergory", isEqualTo: "shop").get();
    query.docs.forEach((doc) async {
      User userM = await User.fromJson(doc.data());

      await userRef
          .doc(userM.id) //Get Document By ID
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          print('Document does not exists on the database');
        } else {
          print(documentSnapshot.data());

          Map<String, dynamic> data = doc.data();
          User user = User.fromJson(data);

          var userRef = FirebaseFirestore.instance;
          userRef
              .collection('User')
              .doc(uid)
              .collection('Pinned')
              .doc(user.id)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (!documentSnapshot.exists) {
              user.pinned = "False";
            } else {
              user.pinned = "True";
            }
          });

          shopList.add(user);
        }
      });
    });

    return shopList;
  }

//get all urls of images
  Future<void> readAllURLs(String? shopname) async {
    String downloadURL = await FirebaseStorage.instance
        .ref("/$shopname")
        .child("Flutter.png")
        .getDownloadURL();
  }

//save a promo
  Future addDocPromotoSaved(String uid, String id, String promoDes, String date,
      String shopName) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Saved')
        .doc(id);

    await document.set({
      'id': id,
      'promoDes': promoDes,
      'date': date,
      'shopName': shopName,
    });
  }

//delete a saved promo
  Future deleteSaved(String uid, String id) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('Saved').doc(id).delete();
  }

//update promo
  Future updateDocPromo(
      String uid, String id, String promoDes, String date) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef
        .collection('User')
        .doc(uid)
        .collection('Promos')
        .doc(id)
        .update({'promoDes': promoDes, 'date': date})
        .then((value) => print("Promo updated"))
        .catchError((error) => print("Failed to update promo: $error"));
  }

//delete a promo
  Future deleteDocPromo(String uid, String id) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('Promos').doc(id).delete();
  }

//pin a shop
  Future addtoPinned(String uid, String id, String name) async {
    final document = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Pinned')
        .doc(id);

    await document.set({
      'id': id,
      'name': name,
    });
  }

//delete a pinned shop
  Future deletePinned(String uid, String id) async {
    var shopRef = FirebaseFirestore.instance;

    shopRef.collection('User').doc(uid).collection('Pinned').doc(id).delete();
  }
}
