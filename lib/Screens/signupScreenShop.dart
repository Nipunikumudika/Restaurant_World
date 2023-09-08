import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

import '../Controllers/authController.dart';
import '../Controllers/userController.dart';
import '../Models/user.dart';
import 'foodDetailPageShop.dart';
import 'logInScreen.dart';

class SignUpScreenShop extends StatefulWidget {
  const SignUpScreenShop({super.key});

  @override
  State<SignUpScreenShop> createState() => _SignUpScreenShopState();
}

class _SignUpScreenShopState extends State<SignUpScreenShop> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController shopnamecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  UserController userController = UserController();

  String errorMessageemail = '';
  String errorMessagepw = '';
  bool? agree = false;
  User? loggedUser;
  // UserController userController = Get.put(UserController());

  // void setUpdb() {
  //   DatabaseSetup databaseSetup = DatabaseSetup();
  //   databaseSetup.setUpDB();
  //   databaseSetup.CreateUserTable();
  // }
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    //setUpdb();
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    signUpUser();
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

  void validatePassword(String val) {
    if (val == "") {
      setState(() {
        errorMessagepw = "Enter Your Password";
      });
    }
  }

  void signUpUser() async {
    AuthController authController = AuthController();
    String? id = await authController.signUpUser(
        emailcontroller.text, passwordcontroller.text);

    if (id != null && countrycontroller != null && shopnamecontroller != null) {
      userController.setID(id);

      await userController.writeNewDoc(id, emailcontroller.text,
          shopnamecontroller.text, countrycontroller.text, "shop");
      await 3000.milliseconds.delay();
      User usr = await userController.getCUser();

      userController.setID(id);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FoodDetailsPageShop(
                    id: id,
                  )));
    } else {
      print("no user");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error Occured".tr),
        duration: Duration(seconds: 1),
        backgroundColor: Color.fromARGB(255, 87, 128, 241),
      ));
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
            Padding(
              padding: EdgeInsets.only(bottom: 30, left: 15),
              child: Row(
                children: [
                  Text(
                    "Sign Up Shop".tr,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/food basket.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  )
                ],
              ),
            ),
            emailInputWidget(emailcontroller),
            passwordInputWidget(passwordcontroller),
            usernameInputWidget(shopnamecontroller),
            catergoryInputWidget(countrycontroller),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TermsAndConditionsScreen()));
                },
                child: Text(
                    "By Signing up I understand and agree to Terms and Conditions"
                        .tr,
                    style: TextStyle(color: Color.fromARGB(255, 52, 15, 239))),
              ),
              value: agree,
              onChanged: (bool? value) {
                setState(() {
                  agree = value!;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30, top: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(200, 40), //////// HERE
                  ),
                  onPressed: _isLoading ? null : _startLoading,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: _isLoading
                        ? SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : Text("Sign Up".tr),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LogInScreen()));
              },
              child: Text(
                "Already have an Account. Click here to Sign In".tr,
                style: TextStyle(color: Color.fromARGB(255, 52, 15, 239)),
              ),
            ),
          ],
        ));
  }

  Widget emailInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Email Address".tr,
              hintText: "Enter Your Email Address".tr,
            ),
            onChanged: (val) {
              validateEmail(val);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              errorMessageemail,
              style: const TextStyle(color: Colors.blue),
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
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            obscureText: true,
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),

              labelText: "Password".tr,
              hintText: "Enter Your Password".tr,
            ),
            onChanged: (val) {
              validatePassword(val);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              errorMessagepw,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget usernameInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Shop Name".tr,
              hintText: "Enter Your Shop Name".tr,
            ),
          ),
        ),
      ],
    );
  }

  Widget catergoryInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Country".tr,
              hintText: "Enter Your Country".tr,
            ),
          ),
        ),
      ],
    );
  }
}
