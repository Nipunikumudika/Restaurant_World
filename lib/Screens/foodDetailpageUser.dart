import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/logInScreen.dart';
import 'package:restaurant_world/Widgets/navBarUser.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/food.dart';
import '../Models/user.dart';
import 'userScreen.dart';

class FoodDetailsPageUser extends StatefulWidget {
  const FoodDetailsPageUser({super.key});

  @override
  State<FoodDetailsPageUser> createState() => _FoodDetailsPageUserState();
}

class _FoodDetailsPageUserState extends State<FoodDetailsPageUser> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  String? shopName;
  User? usr;
  String? id;
  @override
  void initState() {
    super.initState();
    usr = userController.getCUser();
    id = userController.getShopId();

    shopName = shopController.getShopName();
  }

  Future<String> read() async {
    var res;
    await shopController.readAllFoods(id);
    return "ok";
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shopName!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).brightness == Brightness.light
                          ? Colors.blue
                          : Colors.black,

                      //////// HERE
                    ),
                    onPressed: () {
                      shopController.addtoPinned(usr!.id!, id!, shopName!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Pinned".tr),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color.fromARGB(255, 87, 128, 241),
                      ));
                    },
                    child: Text("Pin Shop".tr))
              ],
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
                        itemCount: shopController.allFoodList.value.length,
                        itemBuilder: (context, index) {
                          Food food = shopController.allFoodList.value[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.black),
                              height: 100,
                              margin: EdgeInsets.all(15),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 3,
                                          left: 50,
                                          right: 50),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 80,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.amber
                                            : Colors.black,
                                        child: Image.network(food.url!),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          food.foodName!,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          food.price!,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          food.location!,
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    )
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
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).brightness == Brightness.light
                  ? Colors.blue
                  : Colors.black,

              //////// HERE
            ),
            onPressed: () {
              shopController.clearFoodList();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserScreen()));
            },
            child: Text("Back".tr)),
        Container(height: 60, child: NavBarUser()),
      ]),
    );
  }
}
