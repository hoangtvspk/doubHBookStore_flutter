import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/checkoutInfo.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/request/cartItemRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_data/form_data.dart' as formdata;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../model/address.dart';
import '../model/myInfoModel.dart';
import '../pages/address/addressController.dart';
import '../pages/profile/myProfile/myProfileController.dart';
import '../widgets/flushBar.dart';

class CheckoutController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();
  final _controller = Get.put(AddressController());
  final _controller1 = Get.put(MyProfileController());
  RxBool isEmpty = false.obs;

  Future<CheckOut> getCheckoutInfo(BuildContext context) async {
    MyInfoModel myInfoModel = await _controller1.getBooks(context);
    List<Address> addresses = await _controller.getAddress(context);
    CheckOut checkout =
        new CheckOut(myInfoModel: myInfoModel, addresses: addresses);
    return checkout;
  }
}
