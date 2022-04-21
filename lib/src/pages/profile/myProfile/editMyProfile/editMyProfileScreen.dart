import 'package:doubhBookstore_flutter_springboot/src/model/myInfoModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/myInfoUpdate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../themes/light_color.dart';
import '../../../../widgets/input_text.dart';
import '../../components/profile_menu.dart';
import 'editMyProfileController.dart';

class EditMyProfileScreen extends StatefulWidget {
  EditMyProfileScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EditMyProfileScreenState createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  final _controller = Get.put(EditMyProfileController());
 // final _getProfileController = Get.put(EditMyProfileController());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget Body() {
    return SingleChildScrollView(

        child: FutureBuilder(
            future: _controller.getMyProfile(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              MyInfoModel myInfoModel = snapshot.data;
              if (snapshot.data == null) {
                return Container(child: Center(child: Icon(Icons.error)));
              }
              return Form(

                  key: _formKey,
                  child:Column(
                    children: [
                      InputTextWidget(
                          labelText: "Họ",
                          // initialValue: myInfoModel.firstName.toString(),
                          controller: lastNameController..text=myInfoModel.lastName.toString(),
                          icon: Icons.family_restroom,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25.0,
                      ),
                      InputTextWidget(
                          labelText: "Tên",
                          controller: firstNameController..text=myInfoModel.firstName.toString(),
                          icon: Icons.person,
                          obscureText: false,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ), (myInfoModel.phone!=null)?InputTextWidget(
                          labelText: "Số điện thoại",
                          controller: phoneController..text=myInfoModel.phone.toString(),
                          icon: Icons.phone_android,
                          obscureText: false,
                          keyboardType: TextInputType.text)
                      :InputTextWidget(
                          labelText: "Số điện thoại",
                          controller: phoneController,
                          icon: Icons.phone_android,
                          obscureText: false,
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
                    String firstName = firstNameController.text;
                    String lastName = lastNameController.text;
                    String phone = phoneController.text;
                    MyInfoUpdateModel myInfoUpdate = new MyInfoUpdateModel(firstName: firstName, lastName: lastName, phone: phone);
                    _controller.editMyProfile(lastName,firstName,phone, context);
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
