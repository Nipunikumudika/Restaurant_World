import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_world/Widgets/navBarShop.dart';

import '../Controllers/shopController.dart';
import '../Controllers/userController.dart';
import '../Models/user.dart' as Usr;
import 'foodDetailPageShop.dart';
import 'logInScreen.dart';

class InsertShopDetailScreen extends StatefulWidget {
  const InsertShopDetailScreen({super.key});

  @override
  State<InsertShopDetailScreen> createState() => _InsertShopDetailScreenState();
}

class _InsertShopDetailScreenState extends State<InsertShopDetailScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String? uid;
  File? _photo;
  Usr.User? usr;
  final ImagePicker _picker = ImagePicker();
  final UserController userController = Get.put(UserController());

  final ShopController shopController = Get.put(ShopController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController foodnamecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  bool _isLoading = false;
  void getc() {
    final User? user = auth.currentUser;
    uid = user?.uid;
  }

  @override
  void initState() {
    super.initState();
    getc();
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    AddDetails();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future AddDetails() async {
    final User? user = auth.currentUser;
    String? uid = user?.uid;
    userController.getUserByID(uid);
    usr = userController.getCUser();
    print(usr!.id);

    if (_photo == null) {
      return;
    }

    String fileName = foodnamecontroller.text;
    String? shopname = usr!.name;
    String? url;
    try {
      final storageRef = storage
          .ref("/$shopname") //Folder Structure
          .child(fileName); //File name
      final taskSnapshot = await storageRef.putFile(
        _photo!,
      );
      url = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }

    shopController.writeNewDoc(uid!, foodnamecontroller.text,
        pricecontroller.text, url, usr!.country, usr!.name);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => FoodDetailsPageShop()));
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                foodnameInputWidget(foodnamecontroller),
                priceInputWidget(pricecontroller),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        imgFromGallery();
                      },
                      child: Text('Select An Image'.tr),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey[300],
                  child: _photo != null
                      ? Image.file(_photo!, fit: BoxFit.cover)
                      : Text('Please select an image'.tr),
                ),
                const SizedBox(height: 35),
                Center(
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _startLoading,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: _isLoading
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              )
                            : Text("Add".tr),
                      )),
                ),
              ]),
            ),
            Container(height: 60, child: NavBarShop()),
          ],
        ),
      ),
    );
  }

  Widget foodnameInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Food Name".tr,
              hintText: "Enter Food Name".tr,
            ),
          ),
        ),
      ],
    );
  }

  Widget priceInputWidget(TextEditingController ctrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
              //errorText: "Error",
              border: OutlineInputBorder(),
              labelText: "Price".tr,
              hintText: "Enter the Price".tr,
            ),
          ),
        ),
      ],
    );
  }
}
