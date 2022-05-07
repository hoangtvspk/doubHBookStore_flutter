import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/flushBar.dart';

class BookDetailController extends GetxController{
  var count = 1.obs;
  void increment(int quantity, BuildContext context){
    if(count.value < quantity) {
      count.value ++;
      print(count.value);
    }
    else{
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
  void decrement(int quantity, BuildContext context){
    if(count.value > 1) {
      count.value --;
      print(count.value);
    }
    else{
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
}