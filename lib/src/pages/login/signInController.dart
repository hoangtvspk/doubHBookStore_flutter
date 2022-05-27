import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/pages/mainLayout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../httpClient/config.dart';
import 'package:http/http.dart' as http;

import '../../widgets/flushBar.dart';
import '../home/homeScreen.dart';

class LoginController{
  //final formKey = GlobalKey<FormState>();
  Future signIn(String email, String password, BuildContext context, formKey) async {
    final box = GetStorage();
    final prefs = await SharedPreferences.getInstance();
    var res = await http.post(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["login"]!),
        headers: <String, String>{"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }));
    // print(res.body);
    if (formKey.currentState!.validate()) {
      if (res.statusCode == 200) {
        dynamic e = json.decode(utf8.decode(res.bodyBytes));
        //UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
        box.write("userInfo", e);
        await prefs.setBool('isAuth', true);
        print(prefs.getBool('isAuth'));
        //print(res.body);
        print(box.read("userInfo"));
        Get.to(() =>MainLayout());
        FlushBar.showFlushBar(
          context,
          null,
          "Đăng nhập thành công!",
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        print(res.body);
        FlushBar.showFlushBar(
          context,
          "Đăng nhập thất bại",
          "Tải khoản hoặc mật khẩu chưa chính xác.\nVui lòng nhập lại!",
          Icon(
            Icons.error_outline,
            color: Colors.red, 
          ),
        );
      }
    }
  }

}