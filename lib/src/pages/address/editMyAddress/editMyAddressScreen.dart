import 'package:doubhBookstore_flutter_springboot/src/model/myInfoModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/myInfoUpdate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../model/address.dart';
import '../../../themes/light_color.dart';
import '../../../widgets/input_text.dart';
import 'editMyAddressController.dart';

class EditMyAddressScreen extends StatefulWidget {
  EditMyAddressScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EditMyAddressScreenState createState() => _EditMyAddressScreenState();
}

class _EditMyAddressScreenState extends State<EditMyAddressScreen> {
  final _controller = Get.put(EditMyProfileController());
 // final _getProfileController = Get.put(EditMyProfileController());
  final TextEditingController ProvinceController = TextEditingController();
  final TextEditingController districtTownController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController neighborhoodVillageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget Body() {
    final AddressDetailsArguments agrs =
    ModalRoute.of(context)!.settings.arguments as AddressDetailsArguments;
    print(agrs);
    return SingleChildScrollView(

       child: Form(

                  key: _formKey,
                  child:Column(
                    children: [
                      InputTextWidget(
                          labelText: "Tỉnh/Thành Phố",
                          // initialValue: myInfoModel.firstName.toString(),
                          controller: ProvinceController..text=agrs.address.provinceCity.toString(),
                          icon: Icons.public,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25.0,
                      ),
                      InputTextWidget(
                          labelText: "Huyện/Quận/Thành Phố",
                          controller: districtTownController..text=agrs.address.districtTown.toString(),
                          icon: Icons.family_restroom,
                          obscureText: false,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ), InputTextWidget(
                          labelText: "Xã/Phường",
                          controller: neighborhoodVillageController..text=agrs.address.neighborhoodVillage.toString(),
                          icon: Icons.people,
                          obscureText: false,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ), InputTextWidget(
                          labelText: "Địa chỉ",
                          controller: addressController..text=agrs.address.address.toString(),
                          icon: Icons.person,
                          obscureText: false,
                          keyboardType: TextInputType.text),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  )));

  }

  @override
  Widget build(BuildContext context) {
    final AddressDetailsArguments agrs =
    ModalRoute.of(context)!.settings.arguments as AddressDetailsArguments;
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
                    String province = ProvinceController.text;
                    String district = districtTownController.text;
                    String neiborhood = neighborhoodVillageController.text;
                    String address = addressController.text;
                    //Address myAddress = new Address(id: agrs.address.id, provinceCity: province, districtTown: district, neighborhoodVillage: neiborhood, address: address)
                    _controller.editMyProfile(agrs.address.id,province,district,neiborhood,address, context);
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
                              color: Colors.blue,
                              offset: const Offset(0, 5),
                              blurRadius: 8.0),
                        ],
                        color: Colors.blue, // Color(0xffF05945),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Cập nhật địa chỉ",
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
class AddressDetailsArguments {
  final Address address;
  AddressDetailsArguments({required this.address});
}