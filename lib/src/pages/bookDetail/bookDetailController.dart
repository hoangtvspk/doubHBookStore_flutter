import 'dart:convert';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_data/form_data.dart' as formdata;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../httpClient/config.dart';
import '../../widgets/flushBar.dart';

class BookDetailController extends GetxController {
  var count = 1.obs;
  var rate = 1.0.obs;
  final box = GetStorage();

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
    String review = json.encode(
        {"bookId": bookId, "message": message, "rating": rating.value});
    print(review);
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
  }

  void onProgressing(http.Response data) {
    print(data.body);
  }
}
