import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/request/cartItemRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/cartItem.dart';
import '../../model/categoryModel.dart';
import '../../model/imageModel.dart';
import 'package:http/http.dart' as http;

import '../../widgets/flushBar.dart';

class CartController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();

  Future addOne(int id, Book book) async {
    dynamic cartInfo = await box.read("cartInfo");
    dynamic userInfo = await box.read("userInfo");
    List<CartItemRequest> cartItemRequests = await [];
    List<CartItem> list = await [];
    print("+");
    //Chuyen doi ve json thong qua cartItem
    for (var e in await cartInfo) {
      cartItemRequests
          .add(CartItemRequest(id: e["id"], quantity: e["quantity"]));
    }
    for (var e in await cartItemRequests) {
      if (e.id == id) {
        e.quantity++;
      }
      if (e.quantity > book.quantity) {
        Get.snackbar(
            "Thông báo",
            "Số lượng sách " +
                book.name +
                " không vượt quá " +
                book.quantity.toString() +
                " cuốn");
        return [];
      }
    }
    var body = jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    print(body);
    await http
        .post(
            Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
                Config.APP_API["updateCartItem"]!),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Authorization": userInfo["token"].toString()
            },
            body: body)
        .then((value) => onProgressing(value, list, 1))
        .whenComplete(() {});

    await saveToBox(list);
    return list;
  }

  void cancelLoading(BuildContext context) async {
    context.loaderOverlay.hide();
  }

  void onProgressing(var data, cartItems, int flag) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    // box.write("cartInfo", responseJson);
    for (var e in responseJson) {
      List<ImageModel> imageList = [];
      imageList.add(ImageModel(
          id: e["book"]["bookImages"][0]["id"],
          image: e["book"]["bookImages"][0]["image"]));
      CartItem cartItem = new CartItem(
          id: ((flag == 1)
              ? CartItemID(
                  orderId: e["id"]["orderId"], bookId: e["id"]["bookId"])
              : CartItemID(orderId: -1, bookId: -1)),
          quantity: e["quantity"],
          book: Book(
              id: e["book"]["id"],
              author: e["book"]["author"],
              category: CategoryModel(
                  id: e["book"]["category"]["id"],
                  nameCategory: e["book"]["category"]["nameCategory"]),
              image: imageList,
              detail: e["book"]["detail"],
              name: e["book"]["nameBook"],
              price: e["book"]["price"],
              quantity: e["book"]["quantity"],
              rating: e["book"]["rating"],
              sale: e["book"]["discount"],
              isSelected: false));
      cartItems.add(cartItem);
    }
  }

  Future<List<CartItem>> getCartItems(BuildContext context) async {
    if (box.read("cartInfo") == null) {
      box.write("cartInfo", []);
    }
    dynamic cartInfo = await box.read("cartInfo");
    List<CartItemRequest> cartItemRequests = await [];
    for (var e in await cartInfo) {
      cartItemRequests
          .add(CartItemRequest(id: e["id"], quantity: e["quantity"]));
    }
    var json =
        await jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    // print(json);
    context.loaderOverlay.show(
        widget: Center(
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
    List<CartItem> list = await [];
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      // UserLoginInfoModel userInfo = new UserLoginInfoModel(firstName: e["firstName"], lastName: e["lastName"], email: e["email"], token: e["token"], userRole: e["userRole"]);

      await http
          .post(
              Uri.parse(
                  Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["getCart"]!),
              headers: <String, String>{
                "Content-Type": "application/json",
                "Authorization": userInfo["token"].toString()
              },
              body: json)
          .then((value) => onProgressing(value, list, 1))
          .whenComplete(() => cancelLoading(context));
    } else {
      await http
          .post(
              Uri.parse(
                  Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["makeCart"]!),
              headers: <String, String>{"Content-Type": "application/json"},
              body: json)
          .then((value) => onProgressing(value, list, 0))
          .whenComplete(() => cancelLoading(context));
    }
    saveToBox(list);
    return list;
  }

  saveToBox(List<CartItem> list) {
    List<CartItemRequest> cartItemRequests = [];
    double totalPrice = 0;
    for (CartItem e in list) {
      CartItemRequest cartItemRequest =
          new CartItemRequest(id: e.book.id, quantity: e.quantity);
      cartItemRequests.add(cartItemRequest);
    }
    var json1 = jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    dynamic e = json.decode(json1);
    for (CartItem item in list) {
      Book book = item.book;
      totalPrice += (item.quantity * book.price * (1 - book.sale * 0.01));
    }

    box.write("cartInfo", e);
    box.write("totalItem", list.length);
    box.write("totalPrice", totalPrice);
    print(box.read("cartInfo"));
    // print(box.read("userInfo"));
    // var json = jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    // box.write("cartInfo", json);
  }

  Future addToCart(int id, BuildContext context) async {
    dynamic cartInfo = await box.read("cartInfo");
    dynamic userInfo = await box.read("userInfo");
    String idBook = json.encode({"id": id});
    String quantity = json.encode({"number": 1});
    print("1");
    // FormData formData = FormData;
    // FormData formData = FormData.from({
    //   "idBook": idBook
    // });
    int until = 1;
    var map = new Map<String, String>();
    map['idBook'] = '1';
    map['quantity'] = '2';
    // FormData formData = new FormData(map);
    // formData.fields(
    //     "idBook",
    //     new Blob([JSON.stringify({ id })], { type: "application/json" })
    // );
    //  print(map);
    List<CartItem> list = await [];
    // print(jsonEncode({
    //   "idBook": {"id": "$id"},
    //   "quantity": {"number": 1}
    // }));
    // FormData formData = new FormData.fromMap(map);

    // var res = await http
    //     .post(
    //         Uri.parse(
    //             Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addToCart"]!),
    //         headers: <String, String>{
    //           "Content-Type": "multipart/form-data",
    //           // "Content-Type": "application/json",
    //
    //           "Authorization": userInfo["token"].toString()
    //
    //         },
    //         body: map);

    Map<String, String> headers= <String,String>{
      "Content-Type": "multipart/form-data",
      // "Content-Type": "application/json",

      "Authorization": userInfo["token"].toString()
    };
    var uri = Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addToCart"]!);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(map);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(jsonDecode(respStr)) ;
        // .then((value) => onProgressing(value, list, 1))
        // .whenComplete(() {
      // FlushBar.showFlushBar(
      //   context,
      //   null,
      //   "Thêm giỏ hàng thành công",
      //   Icon(
      //     Icons.check,
      //     color: Colors.green,
      //   ),
      // );
    // });
    // print(res.body);
    saveToBox(list);
    print("2");
  }
}
