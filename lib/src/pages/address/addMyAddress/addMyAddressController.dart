import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/myInfoUpdate.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addressScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/editMyProfile/editMyProfileScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/myProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../httpClient/config.dart';
import '../../../model/imageModel.dart';
import '../../../model/myInfoModel.dart';
import '../../../model/userLoginInfoModel.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/flushBar.dart';

class AddMyProfileController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }

  void onAddInfoProgressing(var data, BuildContext context){
    print(data);
    Get.to(() =>AddressScreen());
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


  Future<void> addMyProfile(String province, String district, String neiboorhood, String address, BuildContext context) async {
    final box = GetStorage();
    dynamic e = (box.read("userInfo"));

    await http
        .post(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addAddress"]!),headers: Config.HEADER,
    body: json.encode({"provinceCity":province,"districtTown":district,"neighborhoodVillage":neiboorhood,"address":address}))
        .then((value) => onAddInfoProgressing(json.decode(utf8.decode(value.bodyBytes)),context))
        .whenComplete(() => cancelLoading(context));
  }
}