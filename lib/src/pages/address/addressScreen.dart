import 'dart:async';

import 'package:doubhBookstore_flutter_springboot/src/checkout/checkoutScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addressController.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/editMyAddress/editMyAddressScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/address.dart';
import '../../model/cartItem.dart';
import 'addMyAddress/addMyAddressScreen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({List<CartItem>? items, Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressController c = Get.put(AddressController());
  final box = GetStorage();
  var formatter = NumberFormat('#,###,000');
  final prefs = SharedPreferences.getInstance();

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Utils.getSizedBox(height: 8),
          RaisedButton(
            onPressed: () {
              Get.to(()=>AddMyAddressScreen())!.then((value) => onChange(value));
            },
            color: Colors.blue,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Thêm địa chỉ mới",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }
  late Future<List<Address>> addressesList = c.getAddress(context);
  loadPage(){
    setState(() {
      addressesList = c.getAddress(context);
    });
  }
  @override
  void initState() {
    super.initState();
  }
  createAddressList() {
    return FutureBuilder(
        future: addressesList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));
          }
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return createCartListItem(snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        });
  }
  FutureOr onChange(dynamic value) {
    loadPage();
    setState(() {});
  }
  createCartListItem(Address address) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          "${address.address}, ${address.neighborhoodVillage}, ${address.districtTown}, ${address.provinceCity}",
                          maxLines: 3,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      Utils.getSizedBox(height: 6),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 8),
                  child: new IconButton(
                    onPressed: () async  {
                      await c.showMyDialog(context, address.id).then(onChange);
                        loadPage();
                        setState(() {});
                    },
                    icon: new Icon(Icons.close, size: 15),
                    color: Colors.white,
                  ),
                  // child: Icon(
                  //   Icons.close,
                  //   color: Colors.white,
                  //   size: 20,
                  // ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.grey.withOpacity(0.3)),
                ),
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: new IconButton(
                    onPressed: () {
                      Get.to(()=>EditMyAddressScreen(),arguments: AddressDetailsArguments(address: address))!.then(onChange);
                      //setState(() {});
                    },
                    icon: new Icon(Icons.edit, size: 15),
                    color: Colors.white,
                  ),
                  // child: Icon(
                  //   Icons.close,
                  //   color: Colors.white,
                  //   size: 20,
                  // ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.grey.withOpacity(0.3)),
                ),
              ],
            )),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    // checkEmpty();

    return Scaffold(
      appBar: AppBar(
        title: Text("Địa chỉ giao hàng"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[createAddressList(), footer(context)],
          );
        },
      ),
    );
  }
}
