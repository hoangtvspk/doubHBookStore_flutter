import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../httpClient/config.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/flushBar.dart';
import '../../widgets/input_text.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage() : super();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cfpasswordController = TextEditingController();
  bool _isLoading = false;

  void cancelLoading() async {
    await EasyLoading.dismiss();
    print('EasyLoading dismiss');
  }

  void onProgressing(res) {
    print(_isLoading.toString());
    String err = "Email đã được sử dụng.\nVui lòng sử dụng tài khoản khác!";
    if (_formKey.currentState!.validate()) {
      if (res.statusCode == 200) {
        Navigator.of(context).pushNamed('/activation');
        FlushBar.showFlushBar(
          context,
          null,
          "Mã kích hoạt đã được gửi đến Email của bạn!",
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        print(_isLoading.toString());
      } else {
        print(json.decode(res.body));
        if (json.decode(res.body)["passwordError"] ==
            "Passwords do not match.") {
          err = "Mật khẩu không trùng khớp.\nVui lòng nhập lại";
        } else if (json.decode(res.body)["emailError"] == "Incorrect email") {
          err = "Email không chính xác.\nVui lòng nhập lại";
        }
        FlushBar.showFlushBar(
          context,
          "Đăng ký thất bại",
          err,
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else
      setState(() {
        EasyLoading.dismiss();
      });
  }

  Future signUp(String firstName, String lastName, String email,
      String password, String password2, BuildContext context) async {
    await EasyLoading.show(
      status: 'Đang xử lý...',
      maskType: EasyLoadingMaskType.black,
    );

    await http
        .post(
            Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
                Config.APP_API["registration"]!),
            headers: <String, String>{"Content-Type": "application/json"},
            body: json.encode({
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": password,
              "password2": password2
            }))
        .then((value) => {onProgressing(value)})
        .catchError((e) {
      print('Got error: $e');
    }).whenComplete(() => cancelLoading());
  }

  @override
  Widget build(BuildContext context) {
    Widget _widgetList() {
      return  Container(
          margin: EdgeInsets.only(top: 110, left: 10, right: 10, bottom: 20),

      child: Column(
        children: [
          SizedBox(
            height: 25.0,
          ),
          Center(
            child: Text(
              'Cửa hàng sách DoubH',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'VL_Hapna',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(top:10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.orange,
                    offset: const Offset(0, 9),
                    blurRadius: 12.0),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputTextWidget(
                      labelText: "Họ",
                      controller: lastNameController,
                      icon: Icons.people_alt_outlined,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 5.0,
                  ),
                  InputTextWidget(
                      labelText: "Tên",
                      controller: firstNameController,
                      icon: Icons.person_outline,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 5.0,
                  ),
                  InputTextWidget(
                      labelText: "Email",
                      controller: emailController,
                      icon: Icons.mail_outline,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 5.0,
                  ),
                  InputTextWidget(
                      labelText: "Mật khẩu",
                      controller: passwordController,
                      icon: Icons.password_outlined,
                      obscureText: true,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: 5.0,
                  ),
                  InputTextWidget(
                      labelText: "Xác nhận mật khẩu",
                      controller: cfpasswordController,
                      icon: Icons.password_outlined,
                      obscureText: true,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ))),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.transparent,
            child: Center(
                child: Wrap(
              children: [
                Text(
                  "Đã có tài khoản? ",
                  style: TextStyle(
                      color: Colors.white70),
                ),
                Material(
                  color: Colors.transparent,
                    child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signin');
                  },
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )),
              ],
            )),
          ),

        ],
      ));
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // leading: Icon(Icons.arrow_back),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Đăng ký tài khoản mới',
            style: TextStyle(
              fontFamily: 'VL_Hapna',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          centerTitle: true,
        ),
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: SpinKitCubeGrid(
              color: Colors.red,
              size: 50.0,
            ),
          ),
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: Container(
            // padding: const EdgeInsets.only(bottom: 70),
            height: AppTheme.fullHeight(context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/signInBackgr.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _widgetList(),
                  Stack(
                    children: [
                      Container(
                        height: 80.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            String firstName = firstNameController.text;
                            String lastName = lastNameController.text;

                            String email = emailController.text;
                            String password = passwordController.text;
                            String password2 = cfpasswordController.text;

                            await signUp(firstName, lastName, email, password,
                                password2, context);
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
                                "Đăng ký",
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
              ),
            ),
          ),
        ));
  }
}
