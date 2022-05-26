import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_data/form_data.dart' as formdata;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
    String review = json.encode({
      "bookId": bookId,
      "message": message,
      "rating": rating.value,
    });
    print(review);
    String files = json.encode("b");
    //File files = File([],"fileName");
    print(files);
    print(bookId);
    print(rating);
    print(message);
    var formData = formdata.FormData();
    formData.add("files", json.encode(""), contentType: 'application/json');
    formData.add("review", review, contentType: 'application/json');
    Map<String, String> headers = <String, String>{
      "Content-Type": formData.contentType,
      // "Content-Type": "application/json",
      "Content-Length": formData.contentLength.toString(),
      "Authorization": userInfo["token"].toString()
    };
    await http
        .post(
            Uri.parse(
                Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["addReview"]!),
            headers: headers,
            body: formData.body)
        .then((value) => onProgressing(value));
  }

  void onProgressing(http.Response data) {
    print(data.body);
  }
}
