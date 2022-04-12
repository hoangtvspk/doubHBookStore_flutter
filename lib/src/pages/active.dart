import 'dart:convert';

import 'package:flutter/material.dart';
import '../httpClient/config.dart';
import '../themes/light_color.dart';
import '../widgets/MessageBox.dart';
import '../widgets/flushBar.dart';
import '../widgets/input_text.dart';
import 'package:http/http.dart' as http;

class ActivationPage extends StatefulWidget {
  ActivationPage() : super();

  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  Future active( String code , BuildContext context) async {
    var res = await http.get(Uri.parse(Config.HTTP_CONFIG["baseURL"]!+Config.APP_API["active2"]!+"/"+code),
        headers: <String, String>{"Content-Type": "application/json"},
     );
    if (_formKey.currentState!.validate()) {
      if(res.statusCode==200){
        print(res.body);
        Navigator.of(context).pushNamed('/signin');
        FlushBar.showFlushBar(context,"Kích hoạt tài khoản thành công!", "Đăng nhập ngay!", Icon(
          Icons.check,
          color: Colors.green,
        ),);
      }
      else{
        FlushBar.showFlushBar(context,null, "Mã xác thực không đúng!\nVui lòng nhập lại!", Icon(
          Icons.error_outline,
          color: Colors.red,
        ),);
      }      }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (195 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;


    Widget _widgetList() {
      return Column(
        children: [
          SizedBox(
            height: 25.0,
          ),
          Center(
            child:
            Text(
              'Cửa hàng sách DoubH',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'VL_Hapna',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  InputTextWidget(
                      labelText: "Mã xác thực",
                      controller: codeController,
                      icon: Icons.people_alt_outlined,
                      obscureText: false,
                     ),
                  SizedBox(
                    height: 25.0,
                  ),


                ],
              )),
          SizedBox(
            height: 10.0,
          ),

        ],
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body:
      SingleChildScrollView(
        child:
        Column(

          children: [
            Container(
              padding: const EdgeInsets.only(bottom:70),
              height: coverHeight - 46,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/loginBackground.png"),
                  fit: BoxFit.fill,

                ),
              ),
              child: Center(
                child:
                Text(
                  'Xác thực tài khoản',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),

            ),
            _widgetList(),
          ],
        ),
      ),
      bottomNavigationBar: Stack(

        children: [
          Container(
            height: 80.0,
            child: ElevatedButton(
              onPressed: () async {
                String code = codeController.text;
                await active(code, context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0.0,
                padding: EdgeInsets.only(left:50, right: 50, top: 9, bottom: 15 ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
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
                    "Kích hoạt tài khoản",
                    textAlign: TextAlign.center,
                    style: TextStyle( fontFamily: 'VL_Hapna', color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}