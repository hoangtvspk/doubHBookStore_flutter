
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../model/userLoginInfoModel.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/title_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);



  Widget _item(Book model) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child:SizedBox.fromSize(
                    size: Size.fromRadius(80),
                    child: Image.asset(model.image[0].image,
                        fit: BoxFit.contain,
                        height: 90,
                        width: 90),
                  ),)
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: model.price.toString(),
                        fontSize: 14,
                      ),
                      TitleText(
                        text: ' \VNĐ ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.quantity}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {

    final box = GetStorage();
    print(box.read("userInfo")!.toString());
    dynamic e = (box.read("userInfo"));
    UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: ' sản phẩm',
            color: LightColor.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            text: userInfo.firstName,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          final box = GetStorage();
          final prefs = await SharedPreferences.getInstance();
          Navigator.pushNamed(context, "/signin");
          await prefs.setBool('isAuth', false);
          print(prefs.getBool('isAuth'));
        },

        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Tiếp tục',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Divider(
              thickness: 1,
              height: 30,
            ),
            _price(),
            SizedBox(height: 30),
            _submitButton(context),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
