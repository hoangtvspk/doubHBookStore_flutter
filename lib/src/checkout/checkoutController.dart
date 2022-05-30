import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/categoryModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/checkoutInfo.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/order.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/request/cartItemRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_data/form_data.dart' as formdata;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../httpClient/config.dart';
import '../model/address.dart';
import '../model/imageModel.dart';
import '../model/myInfoModel.dart';
import '../pages/address/addressController.dart';
import '../pages/login/signInScreen.dart';
import '../pages/profile/myProfile/myProfileController.dart';
import '../widgets/flushBar.dart';

class CheckoutController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();
  final _controller = Get.put(AddressController());
  final _controller1 = Get.put(MyProfileController());
  int selected = -1;
  late Order orderSuccess ;
  RxBool isEmpty = false.obs;

  RxString address = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString phoneNumber = "".obs;

  // RxString address ="".obs;
  // {
  // "address":"125 thôn 15",
  // "firstName":"Hoang",
  // "lastName":"Tran",
  // "email":"hoangtv.spk@gmail.com",
  // "phoneNumber":"0983553096"
  // }

  Future<CheckOut> getCheckoutInfo(BuildContext context) async {
    print("default address");
    MyInfoModel myInfoModel = await _controller1.getBooks(context);
    List<Address> addresses = await _controller.getAddress(context);
    CheckOut checkout =
        new CheckOut(myInfoModel: myInfoModel, addresses: addresses);

    String strEmail = myInfoModel.email;
    String strPhone = myInfoModel.phone;
    String strFirstName = myInfoModel.lastName;
    String strLastName = myInfoModel.firstName;
    String strAddress = addresses[0].address +
        ", " +
        addresses[0].neighborhoodVillage +
        ", " +
        addresses[0].districtTown +
        ", " +
        addresses[0].provinceCity;

    email = await strEmail.obs;
    phoneNumber = await strPhone.obs;
    firstName = await strFirstName.obs;
    lastName = await strLastName.obs;
    address = await strAddress.obs;
    print(email.toString());
    return checkout;
  }

  void cancelLoading(BuildContext context) async {
    context.loaderOverlay.hide();
  }

  Future<void> order(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    print("abc");
    // context.loaderOverlay.show(widget: Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       CircularProgressIndicator(),
    //       SizedBox(height: 12),
    //
    //       Text(
    //         '......',
    //       ),
    //     ],
    //   ),
    // ));
    List list = [];
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http
          .post(
              Uri.parse(
                  Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["order"]!),
              headers: <String, String>{
                "Content-Type": "application/json",
                "Authorization": userInfo["token"].toString()
              },
              body: json.encode({
                "address": address.toString(),
                "firstName": firstName.toString(),
                "lastName": lastName.toString(),
                "email": email.toString(),
                "phoneNumber": phoneNumber.toString()
              }))
          .then((value) => onProgressing(value, 1))
          .whenComplete(() => cancelLoading(context));

      print("success");
    } else {}
    // await saveToBox(list);
    box.write("cartInfo", []);
    box.write("totalPrice", 0);
    box.write("totalItem", 0);
  }
  Future<void> orderByPaypal(BuildContext context) async {
    print("orderPaypal");
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    List list = [];
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      await http
          .post(
          Uri.parse(
              Config.HTTP_CONFIG["baseURL"]! +"/payment1/paypal"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          },
          body: json.encode({
            "address": address.toString(),
            "firstName": firstName.toString(),
            "lastName": lastName.toString(),
            "email": email.toString(),
            "phoneNumber": phoneNumber.toString()
          }));

      print("success");
    } else {}
    // await saveToBox(list);
    await box.write("cartInfo", []);
    await box.write("totalPrice", 0);
    await box.write("totalItem", 0);
    print("finish");
  }

  onProgressing(http.Response data, int i) {
    Map<String, dynamic> response = json.decode(utf8.decode(data.bodyBytes));
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(response);
    // print(response);
    print(prettyprint);

    List<OrderItem> items = [];
    for (var e in response["orderItems"]) {
      OrderItemID itemID = new OrderItemID(
          orderId: e["id"]["orderId"], bookId: e["id"]["bookId"]);
      List<ImageModel> images = [];
      print("bookImage:");
      print(itemID.bookId);
      for (var imageModel in e["book"]["bookImages"]) {
        ImageModel image =
            new ImageModel(id: imageModel["id"], image: imageModel["image"]);
        images.add(image);
      }

      Book book = new Book(
          id: e["book"]["id"],
          name: e["book"]["nameBook"],
          category: new CategoryModel(
              id: e["book"]["category"]["id"],
              nameCategory: e["book"]["category"]["nameCategory"]),
          price: e["book"]["price"],
          sale: e["book"]["discount"],
          quantity: e["book"]["quantity"],
          image: images,
          author: e["book"]["author"],
          detail: e["book"]["detail"],
          rating: e["book"]["rating"],
          review: []);
      OrderItem item =
      new OrderItem(id: itemID, quantity: e["quantity"], book: book);
      items.add(item);
    }
    orderSuccess = new Order(
        id: response["id"],
        address: response["address"],
        firstName: response["firstName"],
        lastName: response["lastName"],
        phoneNumber: response["phoneNumber"],
        email: response["email"],
        date: DateTime.parse(response["date"]),
        totelPrice: response["totalPrice"],
        status: response["status"],
        orderItems: items);

  }

  void onProgressing1(http.Response data) {
    dynamic responseJson = json.decode(utf8.decode(data.bodyBytes));
    Address address1 = new Address(
        id: responseJson["id"],
        provinceCity: responseJson["provinceCity"],
        districtTown: responseJson["districtTown"],
        neighborhoodVillage: responseJson["neighborhoodVillage"],
        address: responseJson["address"]);

    String strAddress = address1.address +
        ", " +
        address1.neighborhoodVillage +
        ", " +
        address1.districtTown +
        ", " +
        address1.provinceCity;

    address = strAddress.obs;
    print(address.toString());

    // box.write("cartInfo", responseJson);
    // Address address1 = new Address(
    //     id: responseJson["id"],
    //     provinceCity: responseJson["provinceCity"],
    //     districtTown: responseJson["districtTown"],
    //     neighborhoodVillage: responseJson["neighborhoodVillage"],
    //     address: responseJson["address"]);
  }

  Future<void> updateUIAddress(int selected) async {
    this.selected = selected;
    print("selected: $selected");
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http.get(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["getAddress"]! +
              "$selected"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          }).then((value) => onProgressing1(value));
    } else {
      Get.to(() => SignInPage());
    }
  }
}
