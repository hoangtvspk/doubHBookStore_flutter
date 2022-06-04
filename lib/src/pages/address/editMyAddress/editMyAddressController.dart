import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../httpClient/config.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/flushBar.dart';

class EditMyProfileController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }

  void onEditInfoProgressing(var data, BuildContext context){
    Get.back();
    FlushBar.showFlushBar(
      context,
      null,
      "Cập nhật địa chỉ thành công!",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }


  Future<void> editMyProfile(int id, String province, String district, String neiboorhood, String address, BuildContext context) async {
    final box = GetStorage();
    dynamic e = (box.read("userInfo"));
    // Address address = new Address(id: id, provinceCity: provinceCity, districtTown: districtTown, neighborhoodVillage: neighborhoodVillage, address: address);
    // print(userInfo.token);


    await http
        .put(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["updateAddress"]!+"$id"),headers: Config.HEADER,
    body: json.encode({"id":id,"provinceCity":province,"districtTown":district,"neighborhoodVillage":neiboorhood,"address":address}))
        .then((value) => onEditInfoProgressing(json.decode(utf8.decode(value.bodyBytes)),context))
        .whenComplete(() => cancelLoading(context));
  }
}