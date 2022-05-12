

import 'package:flutter/material.dart';

class MessageBox{
  static String isFunction = "no";
  static Future<void> myFunction(Future<void> function)async {
    return function;
  }
  static Future<void> showMyDialog(BuildContext context, String title, String message, String button) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(button),
              onPressed: () {
                isFunction = "no";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}