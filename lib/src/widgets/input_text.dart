import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final String? labelText;
  final IconData? icon;
  final bool? obscureText;
  final keyboardType;
  final controller;
  final String? initialValue;


  const InputTextWidget(
      {this.labelText,
        this.icon,
        this.obscureText,
        this.keyboardType,
        this.controller,
        this.initialValue})
      : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            child: TextFormField(
                controller: controller,
                obscureText: obscureText!,
                initialValue: initialValue,
                autofocus: false,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  icon: Icon(
                    icon,
                    color: Colors.blueGrey,
                    size: 30.0, /*Color(0xff224597)*/
                  ),
                  labelText: labelText,
                  labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'VL_Hapna'),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),

                ),
                validator: (val) {
                  String password = "g";
                  if (val!.isEmpty) {
                    return 'Vui lòng nhập vào ' + labelText!;
                  }
                  else if(labelText == "Mật khẩu"){
                    password = val;

                    if(val.length < 6) return 'Mật khẩu ít nhất 6 ký tự';
                    print(password);
                  }
                  // else if(labelText == "Xác nhận mật khẩu" && val != password){
                  //   print(password);
                  //   return "Mật khẩu chưa trùng khớp";
                  // }
                  return null;
                }),
          ),);

  }
}