import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/foodDetailPageShop.dart';
import 'package:restaurant_world/Screens/promosShopScreen.dart';
import 'package:restaurant_world/Screens/settingsScreen.dart';
import 'package:restaurant_world/Screens/userScreen.dart';
import '../Controllers/shopController.dart';
import '../Models/user.dart' as Usr;
import '../Controllers/userController.dart';

class NavBarShop extends StatelessWidget {
  NavBarShop();
  final UserController userController = Get.put(UserController());
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  final ShopController shopController = Get.put(ShopController());
  String? uid;

  void getc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    namecontroller.text = userController.cuser.value.name!;
    countrycontroller.text = userController.cuser.value.country!;
  }

  void UpdateUser(String uid, String country, String name) async {
    await userController.updateUser(uid, country, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Color.fromARGB(255, 71, 180, 75)
            : Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
            ),
            label: 'Edit Details'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Promos'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'DashBoard'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2_outlined),
            label: 'View Shops'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'.tr,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            getc();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text("Update".tr),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: namecontroller,
                            decoration: InputDecoration(
                              labelText: "Shop Name".tr,
                              icon: Icon(Icons.description),
                            ),
                          ),
                          TextFormField(
                            controller: countrycontroller,
                            decoration: InputDecoration(
                              labelText: "Country/Location".tr,
                              icon: Icon(Icons.location_city),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Update"),
                      onPressed: () {
                        try {
                          UpdateUser(uid!, countrycontroller.text,
                              namecontroller.text);
                          userController.getUserByID(uid);
                          countrycontroller.text = countrycontroller.text;
                          namecontroller.text = namecontroller.text;
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Updated Successfully".tr),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color.fromARGB(255, 87, 128, 241),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error Occured".tr),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color.fromARGB(255, 87, 128, 241),
                          ));
                        }
                      },
                    ),
                  ],
                );
              },
            );
          } else if (index == 1) {
            shopController.allShopsPromoList.clear();
            shopController.allPromoList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PromosShopScreen()));
          } else if (index == 2) {
            shopController.allShopsPromoList.clear();
            shopController.allPromoList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FoodDetailsPageShop()));
          } else if (index == 3) {
            shopController.allShopsPromoList.clear();
            shopController.allPromoList.clear();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserScreen()));
          } else if (index == 4) {
            shopController.allPromoList.clear();
            shopController.allShopsPromoList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          }
        },
      ),
    );
  }
}
