import 'dart:async';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addressController.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkoutController.dart';



class EditPlaceOrderScreen extends StatefulWidget {
  const EditPlaceOrderScreen({Key? key}) : super(key: key);

  @override
  _EditPlaceOrderScreenState createState() => _EditPlaceOrderScreenState();
}

class _EditPlaceOrderScreenState extends State<EditPlaceOrderScreen> {
  final AddressController c = Get.put(AddressController());
  final CheckoutController c1 = Get.put(CheckoutController());
  final box = GetStorage();
  var formatter = NumberFormat('#,###,000');
  final prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  createAddressList() {
    return Column(
      children: List.generate(
        c.checkListItems.length,
        (index) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            c.checkListItems[index]["title"],
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          value: c.checkListItems[index]["value"],
          onChanged: (value) {
            setState(() {
              for (var element in c.checkListItems) {
                element["value"] = false;
              }
              c.checkListItems[index]["value"] = value;
              c1.selected = c.checkListItems[index]["id"];
              // c1.selected = selected;
            });
          },
        ),
      ),
    );
  }


  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Utils.getSizedBox(height: 8),
          RaisedButton(
            onPressed: () async {
              await c1.updateUIAddress(c1.selected);
              Navigator.pop(context);
            },
            color: Colors.blue,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Thay đổi",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Địa chỉ giao hàng"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[createAddressList(), footer(context)],
          );
        },
      ),
    );
  }
}
