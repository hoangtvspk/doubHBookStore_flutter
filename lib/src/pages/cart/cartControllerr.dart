import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/request/cartItemRequest.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/cart/emptyCartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_data/form_data.dart' as formdata;

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

import '../../model/reviewModel.dart';
import '../../model/userModel.dart';
import '../../widgets/flushBar.dart';
import '../login/signInScreen.dart';

class CartController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();
  RxBool isEmpty = false.obs;

  void checkEmpty(BuildContext context) {
    this.getCartItems(context);
    dynamic cartInfo = box.read("cartInfo");
    int count = 0;
    for (var e in cartInfo) {
      count++;
    }
    if (box.read("cartInfo") == null) {
      isEmpty = true.obs;
    } else if (count == 0) {
      isEmpty = true.obs;
    } else {
      isEmpty = false.obs;
    }
    print(box.read("cartInfo"));
    print(isEmpty);
  }

  Future addOne(int id, Book book, BuildContext context) async {
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
        FlushBar.showFlushBar(
          context,
          null,
          "Số lượng sách " +
              book.name +
              " không vượt quá " +
              book.quantity.toString() +
              " cuốn",
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
        // Get.snackbar(
        //     "Thông báo",
        //     "Số lượng sách " +
        //         book.name +
        //         " không vượt quá " +
        //         book.quantity.toString() +
        //         " cuốn");
        return;
      }
    }
    var body = jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    print(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["updateCartItem"]!);
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
  }

  Future removeOne(int id, Book book) async {
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
        e.quantity--;
      }
      if (e.quantity < 1) {
        await this.removeItem(id);
        return;
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
  }

  Future removeItem(int id) async {
    dynamic cartInfo = await box.read("cartInfo");
    dynamic userInfo = await box.read("userInfo");
    List<CartItemRequest> cartItemRequests = await [];
    List<CartItem> list = await [];
    for (var e in await cartInfo) {
      cartItemRequests
          .add(CartItemRequest(id: e["id"], quantity: e["quantity"]));
    }
    await http.delete(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
            Config.APP_API["deleteCartItem"]! +
            "$id"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": userInfo["token"].toString()
        }).then((value) => onProgressing(value, list, 1));
    if (list.length == 0) {
      isEmpty = true.obs;
    } else
      isEmpty = false.obs;
    await saveToBox(list);
  }

  void onProgressing(http.Response data, cartItems, int flag) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    print(responseJson);
    // box.write("cartInfo", responseJson);
    for (var e in responseJson) {
      List<ImageModel> imageList = [];
      imageList.add(ImageModel(
          id: e["book"]["bookImages"][0]["id"],
          image: e["book"]["bookImages"][0]["image"]));

      List<ReviewModel> reviewModels = [];

      for (int i = 0; i < e["book"]["reviews"].length; i++) {
        reviewModels.add(ReviewModel(
            id: e["book"]["reviews"][i]["id"],
            user: UserModel(
                id: e["book"]["reviews"][i]["user"]["id"],
                email: e["book"]["reviews"][i]["user"]["email"],
                firstName: e["book"]["reviews"][i]["user"]["firstName"],
                lastName: e["book"]["reviews"][i]["user"]["lastName"]),
            date: e["book"]["reviews"][i]["date"],
            message: e["book"]["reviews"][i]["message"],
            rating: e["book"]["reviews"][i]["rating"]));
      }
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
              review: reviewModels,
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
          .then((value) => onProgressing(value, list, 1));
    } else {
      await http
          .post(
              Uri.parse(
                  Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["makeCart"]!),
              headers: <String, String>{"Content-Type": "application/json"},
              body: json)
          .then((value) => onProgressing(value, list, 0));
    }

    await saveToBox(list);
    // if(list.length == 0){
    //   Get.to(Get.to(() =>EmptyShoppingCartScreen()));
    // }
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
    // print(box.read("userInfo"));
    // var json = jsonEncode(cartItemRequests.map((e) => e.toJson()).toList());
    // box.write("cartInfo", json);
  }

  onAddtoCart(BuildContext context) {
    FlushBar.showFlushBar(
      context,
      null,
      "Thêm giỏ hàng thành công",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  Future addToCart(int id, BuildContext context, RxInt count) async {
    print("Add to cart");
    dynamic cartInfo = await box.read("cartInfo");
    dynamic userInfo = await box.read("userInfo");
    List<CartItem> list = await [];

    if (userInfo == null) {
      Get.to(() => SignInPage());
    } else {
      String idBook = json.encode({
        "id": id,
      });
      String quantity = json.encode({"number": count.value});
      var formData = formdata.FormData();
      formData.add("idBook", idBook, contentType: 'application/json');
      formData.add("quantity", quantity, contentType: 'application/json');

      Map<String, String> headers = <String, String>{
        "Content-Type": formData.contentType,
        // "Content-Type": "application/json",
        "Content-Length": formData.contentLength.toString(),
        "Authorization": userInfo["token"].toString()
      };
      var uri = Uri.parse(
          Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addToCart"]!);
      await http
          .post(uri, headers: headers, body: formData.body)
          .then((value) => onProgressing(value, list, 1))
          .then((value) => onAddtoCart(context));
    }
    ;
    if (list.length == 0) {
      isEmpty = await true.obs;
    } else
      isEmpty = await false.obs;
    await saveToBox(list);
  }
}
