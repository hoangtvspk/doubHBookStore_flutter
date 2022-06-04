import 'dart:convert';
import 'package:doubhBookstore_flutter_springboot/src/pages/checkout/checkoutController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../httpClient/config.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/flushBar.dart';

class AddMyProfileController extends GetxController{
  final _controller = Get.put(CheckoutController());

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }

  void onAddInfoProgressing(var data, BuildContext context){
    _controller.selected = data["id"];
    Get.back();
    FlushBar.showFlushBar(
      context,
      null,
      "Thêm địa chỉ thành công!",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }


  Future<void> addMyProfile(String province, String district, String neiboorhood, String address, BuildContext context) async {
    await http
        .post(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addAddress"]!),headers: Config.HEADER,
    body: json.encode({"provinceCity":province,"districtTown":district,"neighborhoodVillage":neiboorhood,"address":address}))
        .then((value) => onAddInfoProgressing(json.decode(utf8.decode(value.bodyBytes)),context))
        .whenComplete(() => cancelLoading(context));
  }
}