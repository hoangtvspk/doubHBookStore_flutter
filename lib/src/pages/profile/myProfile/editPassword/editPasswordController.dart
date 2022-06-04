import 'dart:convert';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/myProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../httpClient/config.dart';
import '../../../../model/userLoginInfoModel.dart';
import 'package:http/http.dart' as http;
import '../../../../widgets/flushBar.dart';

class EditPasswordController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }

  void onEditPassProgressing(var data, BuildContext context){

      if (data.statusCode == 200) {
        Get.to(() =>MyProfileScreen());
        FlushBar.showFlushBar(
          context,
          null,
          "Cập nhật mật khẩu thành công!",
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        FlushBar.showFlushBar(
          context,
          null,
          "${data.toString()}Mật khẩu chưa chính xác hoặc chưa trùng khớp.\nVui lòng nhập lại!",
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      }

  }


  Future<void> editMyPassword(String password, String newPassword, String newPassword2, BuildContext context) async {
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
        .put(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["editPassword"]!),headers: Config.HEADER,
    body: json.encode({"email":userInfo.email,"password":password,"newPassword":newPassword,"newPassword2":newPassword2}))
        .then((value) => onEditPassProgressing(value,context))
        .whenComplete(() => cancelLoading(context));
  }
}