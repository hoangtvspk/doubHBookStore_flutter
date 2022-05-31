import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/userLoginInfoModel.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  UserLoginInfoModel userInfo =new UserLoginInfoModel(firstName: "", lastName: "", email: "", token: "", userRole: "");
  bool? isAuth = false;
  Future check() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if(isAuth != isAuthh){
      setState(() {
        isAuth = isAuthh;
      });
    }
    if(isAuth! == true) {
      final box = GetStorage();
      dynamic e = (box.read("userInfo"));
      setState(() {
        userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    check();
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/matbiec.jpg"),
              ),
              // Positioned(
              //   right: -16,
              //   bottom: 0,
              //   child: SizedBox(
              //     height: 46,
              //     width: 46,
              //     child: TextButton(
              //       style: TextButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50),
              //           side: BorderSide(color: Colors.white),
              //         ),
              //         primary: Colors.white,
              //         backgroundColor: Color(0xFFF5F6F9),
              //       ),
              //       onPressed: () {},
              //       child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
        SizedBox(height: 7,),
        (isAuth==true)?Text("${userInfo.lastName} ${userInfo.firstName}",
            style: TextStyle(
                fontFamily: 'Roboto-Light',
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                fontSize: 18)):SizedBox()
      ],
    );
  }
}
