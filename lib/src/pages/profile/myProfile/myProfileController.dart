import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../httpClient/config.dart';
import '../../../model/myInfoModel.dart';
import '../../../model/userLoginInfoModel.dart';
import 'package:http/http.dart' as http;

class MyProfileController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }
  void onProgressing(var data, myInfoModel){
    print(data);
    dynamic res = json.decode(utf8.decode(data.bodyBytes));
    MyInfoModel myInfoModel = new MyInfoModel(firstName: res["firstName"], lastName: res["lastName"], email: res["email"], phone: res["phoneNumber"]);
    myInfoModel = myInfoModel;
    }

  Future<MyInfoModel> getBooks(BuildContext context) async {
    final box = GetStorage();
    dynamic e = (box.read("userInfo"));
    UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
    print(userInfo.token);
    final data = await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["userInfo"]!),headers: Config.HEADER).whenComplete(() => cancelLoading(context));
    print(data);
    dynamic res = json.decode(utf8.decode(data.bodyBytes));
    MyInfoModel myInfoModel = new MyInfoModel(firstName: res["firstName"], lastName: res["lastName"], email: res["email"], phone: res["phoneNumber"]);
    print(myInfoModel);
    return myInfoModel;
  }
}