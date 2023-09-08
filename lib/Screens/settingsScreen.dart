import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_world/Screens/logInScreen.dart';

import '../Controllers/userController.dart';
import '../Models/user.dart';
import '../Widgets/navBarShop.dart';
import '../Widgets/navBarUser.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserController userController = Get.put(UserController());
  User? loggedUser;
  String? loggedUserUsername;

  @override
  void initState() {
    super.initState();
  }

  void logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));
  }

  TextEditingController usernameController = TextEditingController();
  String? selectedLanguage;
  String? selectedTheme;
  List<String> languages = ['English', 'Sinhala']; // Option 2
  List<String> themes = ['Light', 'Dark']; // Option 2

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
          padding: EdgeInsets.only(bottom: 10, top: 15),
          child: Center(
            child: Text(
              "Settings".tr,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 90, bottom: 30, left: 15, right: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Change Language".tr,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        DropdownButton(
          hint:
              Text('Please choose a language'.tr), // Not necessary for Option 1
          value: selectedLanguage,
          onChanged: (newValue) {
            setState(() {
              selectedLanguage = newValue as String?;
              if (selectedLanguage == 'English') {
                var locale = Locale('en', 'US');
                Get.updateLocale(locale);
                Locale myLocale = Localizations.localeOf(context);
              } else {
                var locale = Locale('si', 'LK');
                Get.updateLocale(locale);
                Locale myLocale = Localizations.localeOf(context);
              }
            });
          },
          items: languages.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 90, bottom: 30, left: 15, right: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Change Theme".tr,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        DropdownButton(
          hint: Text('Please choose a Theme'.tr), // Not necessary for Option 1
          value: selectedTheme,
          onChanged: (newValue) {
            setState(() {
              selectedTheme = newValue as String?;
              if (selectedTheme == 'Dark') {
                Get.changeThemeMode(ThemeMode.dark);
              } else {
                Get.changeThemeMode(ThemeMode.light);
              }
            });
          },
          items: themes.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              if (userController.cuser.value.catergory == "shop") ...[
                Container(height: 60, child: NavBarShop()),
              ] else ...[
                Container(height: 60, child: NavBarUser()),
              ],
            ],
          ),
        ),
      ]),
    );
  }
}
