import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Widgets/navBarShop.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/promo.dart';
import '../Widgets/navBarUser.dart';
import 'logInScreen.dart';

class SavedPromosScreen extends StatefulWidget {
  const SavedPromosScreen();

  @override
  State<SavedPromosScreen> createState() => _SavedPromosScreenState();
}

class _SavedPromosScreenState extends State<SavedPromosScreen> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  String? uid;
  String? shopName;
  Color starColor = Colors.white;

  void getc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    shopName = userController.cuser.value.name;
  }

  @override
  void initState() {
    super.initState();
    getc();
    shopController.readSavedPromos(uid);
  }

  void logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome!".tr),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                logout();
              },
              child: Text("Logout".tr),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 137, 219, 140)),
            ),
          )
        ],
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Saved Promos".tr,
            style: TextStyle(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Obx(() => SavedPromoList()),
        ),
        Column(
          children: [
            if (userController.cuser.value.catergory == "shop") ...[
              Container(height: 60, child: NavBarShop()),
            ] else ...[
              Container(height: 60, child: NavBarUser()),
            ],
          ],
        ),
      ]),
    );
  }

  ListView SavedPromoList() {
    return ListView.builder(
        itemCount: shopController.savedPromoList.value.length,
        itemBuilder: (context, index) {
          Promo promo = shopController.savedPromoList.value[index];
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.yellow
                    : Colors.black,
              ),
              height: 110,
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      promo.shopName!,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 4, 116, 8),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      promo.promoDes!,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Expire on " + promo.date!,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
