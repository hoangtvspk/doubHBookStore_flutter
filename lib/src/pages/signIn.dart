import 'dart:async';
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/httpClient/config.dart';
import 'package:doubhBookstore_flutter_springboot/src/themes/theme.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/flushBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../themes/light_color.dart';
import '../widgets/input_text.dart';

class SignInPage extends StatefulWidget {
  SignInPage() : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SignInPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Timer _timer;
  bool _isLoaderVisible = false;

  Future signIn(String email, String password, BuildContext context) async {
    var res = await http.post(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["login"]!),
        headers: <String, String>{"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }));
    // print(res.body);
    if (_formKey.currentState!.validate()) {
      if (res.statusCode == 200) {

        print(res.body);
        Navigator.of(context).pushNamed('/mainpage');
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
        //MessageBox.showMyDialog(context, "Không thành công", "Tải khoản hoặc mật khẩu chưa chính xác\nVui lòng nhập lại", "Nhập lại");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (195 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;

    Widget _widgetList() {
      return Container(
          margin: EdgeInsets.only(top: 140, left: 10, right: 10, bottom: 30),
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
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                  child:Column(
                    children: [
                      InputTextWidget(
                          labelText: "Email",
                          controller: emailController,
                          icon: Icons.mail_outline,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25.0,
                      ),
                      InputTextWidget(
                          labelText: "Mật khẩu",
                          controller: passwordController,
                          icon: Icons.password_outlined,
                          obscureText: true,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ))),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                color: Colors.transparent,
                child: Center(
                    child: Wrap(
                  children: [
                    Text(
                      "Chưa có tài khoản? ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold),
                    ),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        )),
                  ],
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    "Hoặc đăng nhập với:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60),
                  ),
                ),
              ),
              Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 10.0, top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey, //Color(0xfff05945),
                                offset: const Offset(0, 0),
                                blurRadius: 5.0),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      width: (screenWidth / 2) - 60,
                      height: 50,
                      child: Material(
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset("assets/icon_fb.png",
                                    fit: BoxFit.cover),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Text("Tài khoản\nFacebook")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 40.0, top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey, //Color(0xfff05945),
                                offset: const Offset(0, 0),
                                blurRadius: 5.0),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      width: (screenWidth / 2) - 60,
                      height: 50,
                      child: Material(
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset("assets/icon_gg.png",
                                    fit: BoxFit.cover),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Text("Tài khoản\nGoogle")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
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
          'Đăng nhập',
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
                            String password = passwordController.text;
                            String email = emailController.text;
                            await signIn(email, password, context);
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
                                "Đăng nhập",
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
            )),
      ),
    );
  }
}
