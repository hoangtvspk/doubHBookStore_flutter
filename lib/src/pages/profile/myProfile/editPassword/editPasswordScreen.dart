import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../themes/light_color.dart';
import '../../../../widgets/input_text.dart';
import '../../components/profile_menu.dart';
import 'editPasswordController.dart';

class EditPasswordScreen extends StatefulWidget {
  EditPasswordScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _controllerEditPassword = Get.put(EditPasswordController());
  final TextEditingController newPassswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasssword2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget Body() {
    return SingleChildScrollView(

        child: FutureBuilder(

            builder: (BuildContext context, AsyncSnapshot snapshot) {

              return Form(

                  key: _formKey,
                  child:Column(
                    children: [
                      InputTextWidget(
                          labelText: "Mật khẩu hiện tại",
                          // initialValue: myInfoModel.firstName.toString(),
                          controller: passwordController,
                          icon: Icons.password_outlined,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25.0,
                      ),
                      InputTextWidget(
                          labelText: "Mật khẩu mới",
                          controller: newPassswordController,
                          icon: Icons.key_outlined,
                          obscureText: true,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ), InputTextWidget(
                          labelText: "Xác nhận mật khẩu",
                          controller: newPasssword2Controller,
                          icon: Icons.key_off_outlined,
                          obscureText: true,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
              //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        //elevation: 0.0,
        title: Text("Thông Tin Cá Nhân"),
      ),
      body: Column(
        children: [
          Body(),
          Stack(
            children: [
              Container(
                height: 80.0,
                child: ElevatedButton(
                  onPressed: () async {
                    String newPassword = newPassswordController.text;
                    String password = passwordController.text;
                    String newPassword2 = newPasssword2Controller.text;
                    _controllerEditPassword.editMyPassword(password,newPassword,newPassword2, context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    padding: EdgeInsets.only(
                        left: 50, right: 50, top: 9, bottom: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColor.orange,
                              offset: const Offset(0, 9),
                              blurRadius: 12.0),
                        ],
                        color: LightColor.orange, // Color(0xffF05945),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Lưu thông tin",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'VL_Hapna',
                            color: Colors.white,
                            fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
