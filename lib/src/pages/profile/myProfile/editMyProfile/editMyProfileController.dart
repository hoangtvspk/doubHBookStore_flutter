import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/myInfoUpdate.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/editMyProfile/editMyProfileScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/myProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../httpClient/config.dart';
import '../../../../model/imageModel.dart';
import '../../../../model/myInfoModel.dart';
import '../../../../model/userLoginInfoModel.dart';
import 'package:http/http.dart' as http;

import '../../../../widgets/flushBar.dart';

class EditMyProfileController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }
  void onGetInfoProgressing(var data, myInfoModel){
    print(data);
    dynamic res = json.decode(utf8.decode(data.bodyBytes));
    MyInfoModel myInfoModel = new MyInfoModel(firstName: res["firstName"], lastName: res["lastName"], email: res["email"], phone: res["phone"]);
    myInfoModel = myInfoModel;
    }
  void onEditInfoProgressing(var data, BuildContext context){
    Get.to(() =>MyProfileScreen());
    FlushBar.showFlushBar(
      context,
      null,
      "Cập nhật hồ sơ thành công!",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  Future<MyInfoModel> getMyProfile(BuildContext context) async {
    final box = GetStorage();
    dynamic e = (box.read("userInfo"));
    UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
    print(userInfo.token);
    // context.loaderOverlay.show(widget: Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       CircularProgressIndicator(),
    //       SizedBox(height: 12),
    //       Text(
    //         'Đang tải dữ liệu...',
    //       ),
    //     ],
    //   ),
    // ));

    final data = await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["userInfo"]!),headers: {'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${userInfo.token.toString()}'});
    print(data);
    dynamic res = json.decode(utf8.decode(data.bodyBytes));
    MyInfoModel myInfoModel = new MyInfoModel(firstName: res["firstName"], lastName: res["lastName"], email: res["email"], phone: res["phoneNumber"]);
    print(myInfoModel);
    return myInfoModel;
  }
  Future<void> editMyProfile(String firstName, String lastName, String phoneNumber, BuildContext context) async {
    final box = GetStorage();
    dynamic e = (box.read("userInfo"));
    UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
    print(userInfo.token);
    context.loaderOverlay.show(widget: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Đang tải dữ liệu...',
          ),
        ],
      ),
    ));

    await http
        .put(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["editProfile"]!),headers: {'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${userInfo.token.toString()}'},
    body: json.encode({"lastName":lastName,"firstName":firstName,"phoneNumber":phoneNumber}))
        .then((value) => onEditInfoProgressing(json.decode(utf8.decode(value.bodyBytes)),context))
        .whenComplete(() => cancelLoading(context));
  }
}