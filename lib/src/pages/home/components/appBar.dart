import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/headerBackg.png"),
              fit: BoxFit.fill,
            )),
        padding: EdgeInsets.only(top: 5, left: 20),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: AssetImage("assets/bookicon2.png"),
                        fit: BoxFit.contain,
                      )),
                  height: 50,
                  width: 50),
              Center(
                // padding: const EdgeInsets.only(left: 80, bottom: 10),
                child: Text(
                  'DouBH',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'VL_Hapna',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}