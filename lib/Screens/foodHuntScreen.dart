import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/food.dart';
import '../Models/user.dart' as cuser;
import '../Widgets/navBarUser.dart';
import 'logInScreen.dart';

class FoodHuntScreen extends StatefulWidget {
  int index = 0;
  FoodHuntScreen(this.index);

  @override
  State<FoodHuntScreen> createState() => _FoodHuntScreenState();
}

class _FoodHuntScreenState extends State<FoodHuntScreen> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  TextEditingController nameController = TextEditingController();
  String? uid;

  void getc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
  }

  void WriteFavShops(String uid, String shopName) async {
    final UserController userController = Get.put(UserController());
    await userController.writeFavShops(uid, shopName);
  }

  void WriteFavFoods(String uid, String shopName) async {
    final UserController userController = Get.put(UserController());
    await userController.writeFavFoods(uid, shopName);
  }

  void DeleteFavShop(String uid, String id) async {
    final UserController userController = Get.put(UserController());
    await userController.deleteFavShop(uid, id);
  }

  void DeleteFavFood(String uid, String id) async {
    final UserController userController = Get.put(UserController());
    await userController.deleteFavFood(uid, id);
  }

  @override
  void initState() {
    super.initState();
    getc();
    userController.readFavShops(uid);
    userController.readFavFoods(uid);
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
        body: DefaultTabController(
            length: 2,
            initialIndex: widget.index,
            child: Scaffold(
                body: SafeArea(
                    child: Column(children: <Widget>[
              PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Shops'.tr,
                    ),
                    Tab(
                      text: 'Foods'.tr,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text("Add"),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: "Shop Name".tr,
                                            icon: Icon(Icons.description),
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
                                      try {
                                        WriteFavShops(
                                            uid!, nameController.text);

                                        Navigator.pop(context, true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Added Successfully".tr),
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              Color.fromARGB(255, 87, 128, 241),
                                        ));
                                        // setState(() {});
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FoodHuntScreen(0)));
                                        nameController.text = "";
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Error Occured".tr),
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              Color.fromARGB(255, 87, 128, 241),
                                        ));
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: Obx(() => ListView.builder(
                          itemCount: userController.favShopList.value.length,
                          itemBuilder: (context, index) {
                            cuser.User user =
                                userController.favShopList.value[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                                height: 50,
                                margin: EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            user.name!,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            DeleteFavShop(uid!, user.id!);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FoodHuntScreen(0)));
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),

                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text("Add".tr),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: "Food Name".tr,
                                            icon: Icon(Icons.description),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Add"),
                                    onPressed: () {
                                      try {
                                        WriteFavFoods(
                                            uid!, nameController.text);

                                        Navigator.pop(context, true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Added Successfully".tr),
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              Color.fromARGB(255, 87, 128, 241),
                                        ));
                                        // setState(() {});
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FoodHuntScreen(1)));

                                        nameController.text = "";
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Error Occured".tr),
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              Color.fromARGB(255, 87, 128, 241),
                                        ));
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: Obx(() => ListView.builder(
                          itemCount: userController.favFoodList.value.length,
                          itemBuilder: (context, index) {
                            Food food = userController.favFoodList.value[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                                height: 50,
                                margin: EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            food.foodName!,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            DeleteFavFood(uid!, food.id!);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FoodHuntScreen(0)));
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),
                    // class name
                  ],
                ),
              ),
              Container(height: 60, child: NavBarUser()),
            ])))));
  }
}
