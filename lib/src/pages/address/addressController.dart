import 'dart:convert';
import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
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
  dynamic addressController = null;

  List checkListItems = [];

  Future<List<Address>> loadAddressForChoose(
      BuildContext context, int selected) async {
    List<Address> addresses = await [];
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      await http
          .get(
              Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
                  Config.APP_API["getAddressByUser"]!),
              headers: Config.HEADER)
          .then((value) => onProgressing(value, addresses));
    } else {
      Get.to(() => SignInPage());
    }
    updateCheckListItem(addresses, selected);
    return addresses;
  }

  void updateCheckListItem(List<Address> addresses, int selected) {
    checkListItems = [];
    int count = 0;
    for (Address address in addresses) {
      count ++;
      bool value =false;
      if (address.id == selected)
        value= true;
      if(selected ==-1 && count == 1){
        value= true;
      }
        dynamic item = {
          "id": address.id,
          "value": value,
          "title": address.address +
              ", " +
              address.neighborhoodVillage +
              ", " +
              address.districtTown +
              ", " +
              address.provinceCity
        };
      checkListItems.add(item);
    }
    print(checkListItems);
  }

  void onProgressing(var data, addresses) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
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
      await http
          .get(
              Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
                  Config.APP_API["getAddressByUser"]!),
              headers: Config.HEADER)
          .then((value) => onProgressing(value, addresses));
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
      http.delete(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["deleteAddress"]! +
              "$id"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          }).then((value) => onDeleteProgressing(context, value));
    } else {
      Get.to(() => SignInPage());
    }
  }

  Future<void> showMyDialog(BuildContext context, int id) async {
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
      await http
          .get(
              Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
                  Config.APP_API["updateAddress"]!),
              headers: Config.HEADER)
          .then((value) => onProgressing(value, addresses));
    } else {
      Get.to(() => SignInPage());
    }
    return addresses;
  }
}
