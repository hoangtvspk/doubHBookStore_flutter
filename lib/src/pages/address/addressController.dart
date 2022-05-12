import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/MessageBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../httpClient/config.dart';
import '../../widgets/flushBar.dart';
import '../login/signInScreen.dart';

class AddressController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();

  void onProgressing(var data, addresses) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    // box.write("cartInfo", responseJson);
    for (var e in responseJson) {
      List<Address> addressesList = [];
      addresses.add(new Address(
          id: e["id"],
          provinceCity: e["provinceCity"],
          districtTown: e["districtTown"],
          neighborhoodVillage: e["neighborhoodVillage"],
          address: e["address"]));
    }

  }
  void onDeleteProgressing(BuildContext context, http.Response data) {
    print(data.body);
    Get.back();
    FlushBar.showFlushBar(
      context,
      null,
      "Xóa địa chỉ thành công!",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  Future<List<Address>> getAddress(BuildContext context) async {
    List<Address> addresses = await [];
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http.get(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["getAddressByUser"]!),
          headers:Config.HEADER).then((value) => onProgressing(value, addresses));
    } else {
      Get.to(() => SignInPage());
    }
    return addresses;
  }
  Future deleteAddress(BuildContext context, int id) async {

    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
      http.delete(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["deleteAddress"]! + "$id"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          }).then((value) => onDeleteProgressing(context, value));
    } else {
      Get.to(() => SignInPage());
    }
  }
  Future<void> showMyDialog(BuildContext context,int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa địa chỉ"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Xóa địa chỉ vừa chọn?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () async {
                await deleteAddress(context, id);
                //
              },
            ),
          ],
        );
      },
    );
  }
  Future<List<Address>> updateAddress(BuildContext context, int id) async {
    List<Address> addresses = await [];
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http.get(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["updateAddress"]!),
          headers: Config.HEADER).then((value) => onProgressing(value, addresses));
    } else {
      Get.to(() => SignInPage());
    }
    return addresses;
  }
}
