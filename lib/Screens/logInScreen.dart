// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

import '../Controllers/authController.dart';
import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/user.dart';
import 'foodDetailPageShop.dart';
import 'signupScreenShop.dart';
import 'signupScreenUser.dart';

import 'userScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final ShopController shopController = Get.put(ShopController());
  String errorMessageemail = '';
  String errorMessagepw = '';
  bool _isLoading = false;
  final UserController userController = Get.put(UserController());

  User? usr;
  void signInUser() async {
    AuthController authController = AuthController();
    String? id = await authController.signInUser(
        emailcontroller.text, passwordcontroller.text);

    if (id != null) {
      userController.setID(id);
      await userController.getUserByID(id);
      User usr = userController.getCUser();

      if (usr.catergory == "shop") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => FoodDetailsPageShop()));
      } else if (usr.catergory == "user") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserScreen()));
      }
    } else {
      print("no user");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Check Username and Password".tr),
        duration: Duration(seconds: 1),
        backgroundColor: Color.fromARGB(255, 87, 128, 241),
      ));
    }
  }

  void validateEmail(String val) {
    if (!EmailValidator.validate(val, true)) {
      setState(() {
        errorMessageemail = "Invalid Email Address";
      });
    } else {
      setState(() {
        errorMessageemail = "";
      });
    }
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    signInUser();
  }

  void validatePassword(String val) {
    if (val == "") {
      setState(() {
        errorMessagepw = "Enter Your Password";
      });
    }
  }

  void changeLanguage(String lan) {
    if (lan == "English") {
      //change to eng
      var locale = Locale('en', 'US');
      Get.updateLocale(locale);
    } else {
      //change to sinhala
      var locale = Locale('si', 'LK');
      Get.updateLocale(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome!".tr),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.changeThemeMode(
                          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                      child: Text("Change Theme".tr),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 137, 219, 140)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Locale myLocale = Get.locale!;
                      if (myLocale == Locale('en', 'US')) {
                        changeLanguage("Sinhala");
                      } else {
                        changeLanguage("English");
                      }
                    },
                    child: Text("Change Language".tr),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 137, 219, 140)),
                  ),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.amber
            : Color.fromARGB(255, 50, 49, 49),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/food basket.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, top: 30),
              child: Text(
                "Sign In".tr,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            emailInputWidget(emailcontroller),
            passwordInputWidget(passwordcontroller),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.light
                        ? Colors.green
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(200, 40), //////// HERE
                  ),
                  onPressed: _isLoading ? null : _startLoading,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: _isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : Text("Sign In".tr),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "No Account. Click below buttons to SignUp".tr,
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).brightness == Brightness.light
                          ? Colors.green
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: Size(200, 40), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreenUser()));
                    },
                    child: Text("Sign Up as User".tr)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).brightness == Brightness.light
                          ? Colors.green
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: Size(200, 40), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreenShop()));
                    },
                    child: Text("Sign Up as a Shop".tr)),
              ],
            ),
          ],
        ));
  }

  Widget emailInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Email Address".tr,
              labelStyle: const TextStyle(
                color: Colors.green, //<-- SEE HERE
              ),
              hintText: "Enter Your Email Address".tr,
            ),
            onChanged: (val) {
              validateEmail(val);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15, bottom: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              errorMessageemail,
              style: const TextStyle(color: Colors.deepPurpleAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(),
              labelText: "Password".tr,
              labelStyle: TextStyle(
                color: Colors.green,
              ),
              hintText: "Enter Your Password".tr,
            ),
            onChanged: (val) {
              validatePassword(val);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              errorMessagepw,
              style: const TextStyle(color: Colors.deepPurpleAccent),
            ),
          ),
        ),
      ],
    );
  }
}
