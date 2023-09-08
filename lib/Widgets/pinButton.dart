import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/shopController.dart';

class PinButton extends StatefulWidget {
  String? uid;
  String? id;
  String? name;
  Color? buttonColor;
  PinButton({
    super.key,
    required this.buttonColor,
    required this.uid,
    required this.id,
    required this.name,
  });
  @override
  State<PinButton> createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  final ShopController shopController = Get.put(ShopController());
  void addDocPromotoPinned(String uid, String id, String name) async {
    await shopController.addtoPinned(uid, id, name);
  }

  void deletePinned(String uid, String id) async {
    await shopController.deletePinned(uid, id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 55,
        child: ElevatedButton(
            onPressed: () {
              if (widget.buttonColor == Colors.grey) {
                widget.buttonColor = Colors.green;

                addDocPromotoPinned(widget.uid!, widget.id!, widget.name!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Pinned"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 87, 128, 241),
                ));
              } else if (widget.buttonColor == Colors.green) {
                deletePinned(widget.uid!, widget.id!);
                widget.buttonColor = Colors.grey;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Unpinned"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 87, 128, 241),
                ));
              }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              primary: widget.buttonColor ?? Colors.grey,
            ),
            child: Icon(Icons.push_pin)));
  }
}
