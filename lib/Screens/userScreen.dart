import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_world/Widgets/navBarUser.dart';
import 'package:restaurant_world/Widgets/pinButton.dart';
import "package:collection/collection.dart";
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/user.dart';
import '../Widgets/navBarShop.dart';
import 'foodDetailPageShop.dart';
import 'foodDetailpageUser.dart';
import 'logInScreen.dart';

class UserScreen extends StatefulWidget {
  String? id;
  String? username;
  String? country;
  String? category;
  UserScreen({super.key, this.id, this.username, this.country, this.category});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  TextEditingController editingController = TextEditingController();
  User? usr;
  String greeting = "Welcome";

  Future<String> read() async {
    var res;
    if (usr!.id == null) {
      await shopController.readShops(widget.id);
      usr!.id = widget.id;
      usr!.name = widget.username;
      usr!.catergory = widget.category;
      usr!.country = widget.country;
    } else {
      await shopController.readShops(usr!.id);
    }

    return "ok";
  }

  List<User> _searchResult = <User>[];

  void _runFilter(String enteredKeyword) {
    _searchResult = shopController.allShopList
        .where((detail) =>
            (detail.name!.toLowerCase().contains(enteredKeyword.toLowerCase())))
        .toList();
    setState(() {});
    if (enteredKeyword == "") {
      setState(() {
        _searchResult.clear();
      });
    }
  }

  void logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));
  }

  @override
  void initState() {
    super.initState();
    usr = userController.getCUser();

    shopController.clearShopList;
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Dashboard".tr,
              style: TextStyle(
                color: Colors.green,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 80,
            child: TextField(
              controller: editingController,
              onChanged: (value) => _runFilter(editingController.text),
              decoration: InputDecoration(
                  labelText: "Search".tr,
                  hintText: "Search".tr,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
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
                    return Column(
                      children: [
                        if (_searchResult.isEmpty) ...[
                          new Flexible(
                              child: ListViewShop(
                                  shopController.allShopList.value)),
                        ] else ...[
                          new Flexible(child: ListViewShop(_searchResult)),
                        ],
                      ],
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
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
        ],
      ),
    );
  }

  ListView ListViewShop(list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          User user = list[index];
          return GestureDetector(
            onTap: () {
              userController.setShopId(user.id!);
              shopController.setShopName(user.name!);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodDetailsPageUser()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.yellow
                    : Colors.black,
              ),
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.name!,
                      style: TextStyle(
                          color: Color.fromARGB(255, 4, 116, 7),
                          fontWeight: FontWeight.bold),
                    ),
                    if (usr!.catergory == 'user') ...[
                      if (user.pinned == "True") ...[
                        PinButton(
                          buttonColor: Colors.green,
                          uid: usr!.id,
                          id: user.id!,
                          name: user.name,
                        )
                      ] else ...[
                        PinButton(
                          buttonColor: Colors.grey,
                          uid: usr!.id,
                          id: user.id!,
                          name: user.name,
                        )
                      ],
                    ]
                  ],
                ),
              ),
            ),
          );
        });
  }

  get(Uri uri) {}
}
