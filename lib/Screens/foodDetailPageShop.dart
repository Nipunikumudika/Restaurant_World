import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Widgets/navBarShop.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/food.dart';
import 'insertShopDetailScreen.dart';
import 'logInScreen.dart';

class FoodDetailsPageShop extends StatefulWidget {
  String? id;

  FoodDetailsPageShop({super.key, this.id});

  @override
  State<FoodDetailsPageShop> createState() => _FoodDetailsPageShopState();
}

class _FoodDetailsPageShopState extends State<FoodDetailsPageShop> {
  final UserController userController = Get.put(UserController());
  final ShopController shopController = Get.put(ShopController());
  TextEditingController foodNamecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  String? uid;

  void getc() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
  }

  void updateDoc(String uid, String id, String foodName, String price) async {
    await shopController.updateDoc(uid, id, foodName, price);
  }

  void deleteDoc(String uid, String id, String url) async {
    await shopController.deleteDoc(uid, id, url);
  }

  List<Food> _searchResult = <Food>[].obs;

  void _runFilter(String enteredKeyword) {
    _searchResult = shopController.allFoodList
        .where((detail) => (detail.foodName!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())))
        .toList();
    setState(() {});
    if (enteredKeyword == "") {
      setState(() {
        _searchResult.clear();
      });
    }
  }

  Future<String> read() async {
    var res;
    if (uid == null) {
      await shopController.readAllFoods(widget.id);
      await userController.getUserByID(widget.id);
      await 3000.milliseconds.delay();
    } else {
      await userController.getUserByID(uid);
      await 3000.milliseconds.delay();
    }
    if (_searchResult.isEmpty) {
      await shopController.readAllFoods(uid);
    }
    return "ok";
  }

  @override
  void initState() {
    super.initState();
    getc();
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
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => InsertShopDetailScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Shop Dashboard".tr,
            style: const TextStyle(
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
                            child:
                                ListViewShop(shopController.allFoodList.value)),
                      ] else ...[
                        new Flexible(child: ListViewShop(_searchResult)),
                      ],
                    ],
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Container(height: 60, child: NavBarShop()),
      ]),
    );
  }

  ListView ListViewShop(list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Food food = list[index];
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.amber
                    : Colors.black,
              ),
              height: 110,
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 3, left: 50, right: 30),
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 80,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.amber
                            : Colors.black,
                        child: Image.network(food.url!),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            food.foodName!,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            food.price!,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5.0)), /////// HERE
                            ),
                            onPressed: () {
                              foodNamecontroller.text = food.foodName!;
                              pricecontroller.text = food.price!;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: Text("Update".tr),
                                    content: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Form(
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: foodNamecontroller,
                                              decoration: InputDecoration(
                                                labelText: "Food Name".tr,
                                                icon: Icon(Icons.food_bank),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: pricecontroller,
                                              decoration: InputDecoration(
                                                labelText: "Price".tr,
                                                icon: Icon(Icons.price_change),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Update".tr),
                                        onPressed: () {
                                          updateDoc(
                                              uid!,
                                              food.id!,
                                              foodNamecontroller.text,
                                              pricecontroller.text);
                                          Navigator.pop(context, true);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoodDetailsPageShop()));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.edit, color: Colors.green)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5.0)), /////// HERE
                            ),
                            onPressed: () {
                              deleteDoc(uid!, food.id!, food.url!);
                              setState(() {});
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FoodDetailsPageShop()));
                            },
                            child: Icon(Icons.delete,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.green
                                    : Colors.black)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
