import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../httpClient/config.dart';
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

  Future<List<Address>> getAddress(BuildContext context) async {
    List<Address> addresses = await [];
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http.post(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["getAddressByUser"]!),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          }).then((value) => onProgressing(value, addresses));
    } else {
      Get.to(() => SignInPage());
    }
    print(addresses.toString());
    return addresses;
  }
}
