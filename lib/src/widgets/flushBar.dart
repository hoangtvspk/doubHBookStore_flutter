import 'package:another_flushbar/flushbar.dart';
// import 'package:flushbar/flushbar.dart';
 import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlushBar{
  static Future<Flushbar> showFlushBar(BuildContext context, String? title, String message, Icon icon) async {

    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      message : message,
      duration : Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
      // reverseAnimationCurve: Curves.decelerate,
      // forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      margin: EdgeInsets.only(top: 60, left:60, right: 60),
      borderRadius: BorderRadius.circular(8),
      boxShadows: [BoxShadow(color: Colors.blueGrey[800]!, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.white10]),
      isDismissible: false,
      icon: icon
    )
      ..show(context);
        }


    }

