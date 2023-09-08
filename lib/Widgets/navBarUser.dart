import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/AllPromosScreen.dart';
import 'package:restaurant_world/Screens/foodHuntScreen.dart';
import 'package:restaurant_world/Screens/promosShopScreen.dart';
import 'package:restaurant_world/Screens/settingsScreen.dart';
import 'package:restaurant_world/Screens/userScreen.dart';

import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';

class NavBarUser extends StatelessWidget {
  NavBarUser();

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
            label: 'Dashboard'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Food Hunt'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'.tr,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            shopController.allShopList.clear();
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
                              labelText: "Name".tr,
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
                      child: Text("Update".tr),
                      onPressed: () {
                        try {
                          UpdateUser(uid!, countrycontroller.text,
                              namecontroller.text);
                          userController.getUserByID(uid);
                          countrycontroller.text = countrycontroller.text;
                          namecontroller.text = namecontroller.text;
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

                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            );
          } else if (index == 1) {
            shopController.allShopList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AllPromosScreen()));
          } else if (index == 2) {
            shopController.allShopList.clear();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserScreen()));
          } else if (index == 3) {
            shopController.allShopList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FoodHuntScreen(0)));
          } else if (index == 4) {
            shopController.allShopList.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          }
        },
      ),
    );
  }
}
