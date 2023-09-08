import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/savedPromosScreen.dart';
import 'package:restaurant_world/Widgets/saveButton.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/promo.dart';
import '../Widgets/navBarShop.dart';
import 'AllPromosScreen.dart';
import 'logInScreen.dart';

class PromosShopScreen extends StatefulWidget {
  const PromosShopScreen();

  @override
  State<PromosShopScreen> createState() => _PromosShopScreenState();
}

class _PromosShopScreenState extends State<PromosShopScreen> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  TextEditingController promoDescontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  String? uid;
  String? shopName;

  void getc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    shopName = userController.cuser.value.name;
  }

  void updateDocPromo(
      String uid, String id, String promoDes, String date) async {
    await shopController.updateDocPromo(uid, id, promoDes, date);
  }

  void addDocPromo(
      String uid, String promoDes, String date, String shopName) async {
    await shopController.addDocPromo(uid, promoDes, date, shopName);
  }

  void addDocPromotoSaved(String uid, String id, String promoDes, String date,
      String shopName) async {
    await shopController.addDocPromotoSaved(uid, id, promoDes, date, shopName);
  }

  void deleteDocPromo(String uid, String id) async {
    await shopController.deleteDocPromo(uid, id);
  }

  Future<String> read() async {
    var res;
    await shopController.readAllPromos(uid);
    await 1000.milliseconds.delay();
    return "ok";
  }

  @override
  void initState() {
    super.initState();
    getc();

    read().then((Value) {
      setState(() {});
    });
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.light
                        ? Colors.blue
                        : Colors.black,

                    //////// HERE
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedPromosScreen()));
                  },
                  child: Text("View Saved Promos".tr)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.light
                        ? Colors.blue
                        : Colors.black,

                    //////// HERE
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllPromosScreen()));
                  },
                  child: Text("View All Promos".tr)),
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text("Add Promo".tr),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: promoDescontroller,
                                decoration: InputDecoration(
                                  labelText: "Promo Description".tr,
                                  icon: Icon(Icons.description),
                                ),
                              ),
                              TextFormField(
                                controller: datecontroller,
                                decoration: InputDecoration(
                                  labelText: "Last Date".tr,
                                  icon: Icon(Icons.date_range),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text("Add".tr),
                          onPressed: () {
                            shopController.allPromoList.clear();
                            addDocPromo(uid!, promoDescontroller.text,
                                datecontroller.text, shopName!);
                            Navigator.pop(context, true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PromosShopScreen()));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Shop Promos",
            style: TextStyle(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: read(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data as String;
                  return Container(
                    child: Obx(() => ListView.builder(
                        itemCount: shopController.allPromoList.value.length,
                        itemBuilder: (context, index) {
                          Promo promo =
                              shopController.allPromoList.value[index];
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).brightness ==
                                        Brightness.light
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
                                      width: 290,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            shopName!,
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Color.fromARGB(
                                                    255, 4, 116, 8),
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)), /////// HERE
                                            ),
                                            onPressed: () {
                                              promoDescontroller.text =
                                                  promo.promoDes!;
                                              datecontroller.text = promo.date!;
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: Text("Update".tr),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller:
                                                                  promoDescontroller,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Promo Description"
                                                                        .tr,
                                                                icon: Icon(Icons
                                                                    .food_bank),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  datecontroller,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Date".tr,
                                                                icon: Icon(Icons
                                                                    .date_range),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        child:
                                                            Text("Update".tr),
                                                        onPressed: () {
                                                          shopController
                                                              .allPromoList
                                                              .clear();
                                                          updateDocPromo(
                                                              uid!,
                                                              promo.id!,
                                                              promoDescontroller
                                                                  .text,
                                                              datecontroller
                                                                  .text);
                                                          Navigator.pop(
                                                              context, true);
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PromosShopScreen()));
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.edit,
                                                color: Colors.green)),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)), /////// HERE
                                            ),
                                            onPressed: () {
                                              shopController.allPromoList
                                                  .clear();

                                              deleteDocPromo(uid!, promo.id!);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PromosShopScreen()));
                                            },
                                            child: Icon(Icons.delete,
                                                color: Colors.green)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Container(
          height: 60,
        ),
        Container(height: 70, child: NavBarShop()),
      ]),
    );
  }
}
