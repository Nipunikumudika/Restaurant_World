import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/shopController.dart';

class SaveButton extends StatefulWidget {
  String? uid;
  String? id;
  String? promoDes;
  String? date;
  String? shopName;
  Color? buttonColor;
  SaveButton(
      {super.key,
      required this.buttonColor,
      required this.uid,
      required this.id,
      required this.promoDes,
      required this.date,
      required this.shopName});
  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  final ShopController shopController = Get.put(ShopController());
  void addDocPromotoSaved(String uid, String id, String promoDes, String date,
      String shopName) async {
    await shopController.addDocPromotoSaved(uid, id, promoDes, date, shopName);
  }

  void deleteSaved(String uid, String id) async {
    await shopController.deleteSaved(uid, id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 55,
        child: ElevatedButton(
            onPressed: () {
              if (widget.buttonColor == Colors.grey) {
                widget.buttonColor = Colors.green;

                addDocPromotoSaved(widget.uid!, widget.id!, widget.promoDes!,
                    widget.date!, widget.shopName!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Saved"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 87, 128, 241),
                ));
              } else if (widget.buttonColor == Colors.green) {
                deleteSaved(widget.uid!, widget.id!);
                widget.buttonColor = Colors.grey;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("UnSaved"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 87, 128, 241),
                ));
              }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              primary: widget.buttonColor ?? Colors.grey,
            ),
            child: const Icon(Icons.save)));
  }
}
