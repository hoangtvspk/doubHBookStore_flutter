import 'package:doubhBookstore_flutter_springboot/src/pages/address/addressScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../books/Search.dart';
import '../../login/signInScreen.dart';
import '../../myOrders/orderScreen.dart';
import '../myProfile/myProfileScreen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  Body({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();
  bool? isAuth = false;

  Future check() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    setState(() {
      isAuth = isAuthh;
    });
  }
  void signOut() async{
    Get.to(() =>SignInPage());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuth', false);
    box.remove("userInfo");
  }
  @override
  Widget build(BuildContext context){
    check();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: (isAuth == true)?Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Thông Tin Cá Nhân",
            icon: Icons.person_outline,
            press: () => {
              Get.to(() => MyProfileScreen())
            },
          ),
          ProfileMenu(
            text: "Địa Chỉ Giao Hàng",
            icon: Icons.paste_rounded,
            press:  () => {
              Get.to(() => AddressScreen())
            },
          ),
          ProfileMenu(
            text: "Quản Lý Đơn Hàng",
            icon: Icons.bookmark_border_sharp,
            press:  () => {
              Get.to(() => OrderScreen())
            },
          ),
          ProfileMenu(
            text: "Tìm kiếm",
            icon: Icons.search,
            press: () {
              Get.to(()=> SearchPage());
            },
          ),
          ProfileMenu(
            text: "Đăng Xuất",
            icon: Icons.logout,
            press: () {signOut();},
          ),
        ],
      ):Column(
          children: [
          ProfilePic(),
        SizedBox(height: 20),
        ProfileMenu(
          text: "Đăng nhập/Đăng ký",
          icon: Icons.person_outline,
          press: () => {Get.to(() => SignInPage())},
        ), ]),

    );
  }
}
