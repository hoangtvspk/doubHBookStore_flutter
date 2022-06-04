import 'dart:convert';
import 'package:doubhBookstore_flutter_springboot/src/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/categoryModel.dart';
import '../../model/imageModel.dart';

class OrderController extends GetxController {
  final box = GetStorage();
  final prefs = SharedPreferences.getInstance();
  RxBool isEmpty = false.obs;

  Future<List<Order>> getUserOrder(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAuthh = await prefs.getBool("isAuth");

    List<Order> list = [];
    if (isAuthh == true) {
      dynamic userInfo = await (box.read("userInfo"));
      await http.get(
          Uri.parse(
              Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["purchase"]!),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          }).then((value) => onProgressing(value, list));

    } else {}
    print(list.length);
    return list.reversed.toList();
  }

  onProgressing(http.Response data, List<Order> list) {
    List<dynamic> response = json.decode(utf8.decode(data.bodyBytes));
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(response);
    print(prettyprint);
    for (var i in response) {
      List<OrderItem> items = [];
      for (var e in i["orderItems"]) {
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
      list.add(new Order(
          id: i["id"],
          address: i["address"],
          firstName: i["firstName"],
          lastName: i["lastName"],
          phoneNumber: i["phoneNumber"],
          email: i["email"],
          date: DateTime.parse(i["date"]),
          totelPrice: i["totalPrice"],
          status: i["status"],
          orderItems: items));
    }
  }
}
