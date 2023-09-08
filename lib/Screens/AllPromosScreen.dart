import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/logInScreen.dart';
import 'package:restaurant_world/Screens/savedPromosScreen.dart';
import 'package:restaurant_world/Widgets/navBarUser.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/promo.dart';
import '../Widgets/navBarShop.dart';
import '../Widgets/saveButton.dart';

class AllPromosScreen extends StatefulWidget {
  const AllPromosScreen();

  @override
  State<AllPromosScreen> createState() => _AllPromosScreenState();
}

class _AllPromosScreenState extends State<AllPromosScreen> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  TextEditingController promoDescontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  String? uid;
  String? shopName;
  Color starColor = Colors.white;

  void getc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    shopName = userController.cuser.value.name;
  }

  void addDocPromotoSaved(String uid, String id, String promoDes, String date,
      String shopName) async {
    await shopController.addDocPromotoSaved(uid, id, promoDes, date, shopName);
  }

  Future<void> read() async {
    var res;
    await shopController.readAllShopPromos(uid);

    await 1000.milliseconds.delay();
  }

  @override
  void initState() {
    super.initState();
    getc();

    if (shopController.allShopsPromoList.value.length == 0) {
      read().then((Value) {
        setState(() {});
      });
    }
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
            "All Shop Promos".tr,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Obx(() => AllPromosList()),
          ),
        ),
        Column(
          children: [
            if (userController.cuser.value.catergory == "shop") ...[
              Container(height: 60, child: NavBarShop()),
            ] else ...[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.light
                        ? Colors.green
                        : Colors.black,

                    //////// HERE
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedPromosScreen()));
                  },
                  child: Text("Saved Promos".tr)),
              Container(height: 60, child: NavBarUser()),
            ],
          ],
        ),
      ]),
    );
  }

  ListView AllPromosList() {
    return ListView.builder(
        itemCount: shopController.allShopsPromoList.value.length,
        itemBuilder: (context, index) {
          Promo promo = shopController.allShopsPromoList.value[index];
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
                child: Row(
                  children: [
                    if (promo.saved == "True") ...[
                      SaveButton(
                          buttonColor: Colors.green,
                          uid: uid,
                          id: promo.id,
                          promoDes: promo.promoDes,
                          date: promo.date,
                          shopName: promo.shopName),
                    ] else ...[
                      SaveButton(
                          buttonColor: Colors.grey,
                          uid: uid,
                          id: promo.id,
                          promoDes: promo.promoDes,
                          date: promo.date,
                          shopName: promo.shopName),
                    ],
                    Container(
                      width: 300,
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
