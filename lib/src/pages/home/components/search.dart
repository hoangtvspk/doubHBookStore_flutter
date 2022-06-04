import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../themes/light_color.dart';
import '../../books/Search.dart';

class Search extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                onTap: (){
                  Get.to(()=> SearchPage());
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Bạn tìm sách gì hôm nay...",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 18, top: 0),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  }