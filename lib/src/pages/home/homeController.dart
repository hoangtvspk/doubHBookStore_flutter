import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/categoryModel.dart';
import '../../model/imageModel.dart';
import 'package:http/http.dart' as http;
class HomeController extends GetxController{

  void cancelLoading(BuildContext context)async
  {
    context.loaderOverlay.hide();
  }
  void onProgressing(var data, bookList){

    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [] ;
      for (int i =0;i<e["bookImages"].length;i++){
        imageList.add(ImageModel(id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"] ,category: CategoryModel(id: e["category"]["id"],nameCategory: e["category"]["nameCategory"]),image: imageList,price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false,detail: e["detail"],rating: e["rating"],review: e["book"]["reviews"] );

      bookList.add(book);
    }

  }
  Future<List<Book>> getNewBooks(BuildContext context) async {

    context.loaderOverlay.show(widget: Center(
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

    List<Book> bookList = [];
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["newBook"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading(context));

    return bookList;
  }

  Future<List<Book>> getBestSaleBooks(BuildContext context) async {
    context.loaderOverlay.show(widget: Center(
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

    List<Book> bookList = [];
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["bestSellingBook"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading(context));
    // List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    // // for (var e in responseJson) {
    // //   Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"] ,category: e["category"]["nameCategory"],image: e["bookImages"][0]["image"].toString(),price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false );
    // //   // book.id = e["id"];
    // //   // book.name = e["nameBook"];
    // //   // book.author = e["author"];
    // //   // book.category = e["category"]["nameCategory"];
    // //   // book.image = e["bookImages"][0]["image"].toString();
    // //   // book.price = e["price"];
    // //   // book.sale = e["discount"];
    // //   bookList.add(book);
    // }

    return bookList;
  }

  Future<List<Book>> getBestDiscountBooks(BuildContext context) async {
    context.loaderOverlay.show(widget: Center(
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

    List<Book> bookList = [];
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["bestDiscountBook"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading(context));
    return bookList;
  }
}