import 'package:doubhBookstore_flutter_springboot/src/model/myInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/profile_menu.dart';
import 'myProfileController.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _controller = Get.put(MyProfileController());

  Widget Body() {
    return SingleChildScrollView(

        child: FutureBuilder(
            future: _controller.getBooks(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              MyInfoModel myInfoModel = snapshot.data;
              if (snapshot.data == null) {
                return Container(child: Center(child: Icon(Icons.error)));
              }
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border( bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                    child: Row(
                      children: [
                        Text(
                          "Họ:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),
                        Spacer(),
                        Text(
                          myInfoModel.lastName,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border( bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          "Tên:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),
                        Spacer(),
                        Text(
                          myInfoModel.firstName,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                        border: Border( bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.3)))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          "Email:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),
                        Spacer(),
                        Text(
                          myInfoModel.email,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border( bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.3)))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          "Số điện thoại:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),
                        Spacer(),
                        (myInfoModel.phone == null)
                            ? Text(
                          "",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        )
                            : Text(
                          "${myInfoModel.phone}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  ProfileMenu(
                    text: "Chỉnh sửa thông tin",
                    icon: Icons.person_outline,
                    press: () => {},
                  ),
                  ProfileMenu(
                    text: "Cập nhật mật khẩu",
                    icon: Icons.password_outlined,
                    press: () => {},
                  ),
                ],
              );
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
      body: Body(),
    );
  }
}
