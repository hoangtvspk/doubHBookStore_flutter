import 'dart:convert';
import 'dart:io';

import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:form_data/form_data.dart' as formdata;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../httpClient/config.dart';
import '../../model/categoryModel.dart';
import '../../model/imageModel.dart';
import '../../model/reviewModel.dart';
import '../../model/userModel.dart';
import '../../widgets/flushBar.dart';
import '../login/signInScreen.dart';

class BookDetailController extends GetxController {
  var count = 1.obs;
  var rate = 1.0.obs;
  final box = GetStorage();
  late Book book;
  int isChangeReview = 0;
  var isFavor = false.obs;
  void increment(int quantity, BuildContext context) {
    if (count.value < quantity) {
      count.value++;
      print(count.value);
    } else {
      FlushBar.showFlushBar(
        context,
        null,
        "Vượt quá số lượng trong kho",
        Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }
  }

  void decrement(int quantity, BuildContext context) {
    if (count.value > 1) {
      count.value--;
      print(count.value);
    } else {
      FlushBar.showFlushBar(
        context,
        null,
        "Không thể nhỏ hơn 0",
        Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }
  }

  void rating(double quantity) {
    rate.value = quantity;
  }

  Future addReview(int bookId, String message, RxDouble rating) async {
    dynamic userInfo = await box.read("userInfo");
    print("addReview");
    String review = json
        .encode({"bookId": bookId, "message": message, "rating": rating.value});
    print(review);
    if (userInfo == null) {
      Get.to(() => SignInPage());
    } else {
      await http
          .post(
          Uri.parse(
              Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addReview"]!),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": userInfo["token"].toString()
          },
          body: review)
          .then((value) => onProgressing(value));
      isChangeReview = 1;
    }
  }
  addToFavor(){
    isFavor.value = true;
  }
  removeToFavor(){
    isFavor.value = false;
  }


  // Future<Book> getBookByID(int bookId) async {
  //   // dynamic userInfo = await box.read("userInfo");
  //   await http.get(
  //       Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
  //           Config.APP_API["bookDetail"]! +
  //           "$bookId"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //       }).then((value) => onProgressing(value, book));
  //   return book;
  // }

  void onProgressing(http.Response data) {

    dynamic e = json.decode(utf8.decode(data.bodyBytes));
    List<ImageModel> imageList = [] ;
    for (int i =0;i<e["bookImages"].length;i++){
      imageList.add(ImageModel(id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
    }
    List<ReviewModel> reviewList = [] ;
    for (int i =0;i<e["reviews"].length;i++){
      reviewList.add(ReviewModel(id: e["reviews"][i]["id"], user: UserModel(id:e["reviews"][i]["user"]["id"] , email: e["reviews"][i]["user"]["email"], firstName: e["reviews"][i]["user"]["firstName"], lastName: e["reviews"][i]["user"]["lastName"]) , date: e["reviews"][i]["date"], message: e["reviews"][i]["message"], rating: e["reviews"][i]["rating"]));
    }
    book = new Book(
        id: e["id"],
        name: e["nameBook"],
        author: e["author"],
        category: CategoryModel(
            id: e["category"]["id"],
            nameCategory: e["category"]["nameCategory"]),
        image: imageList,
        price: e["price"],
        sale: e["discount"],
        quantity: e["quantity"],
        isSelected: false,
        detail: e["detail"],
        rating: e["rating"],
        review: reviewList);
  }
}
