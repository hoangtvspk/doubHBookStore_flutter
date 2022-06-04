import 'package:flutter/material.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';

import '../myOrders/orderSuccess.dart';

class OrderPlacePage extends StatefulWidget {
  @override
  _OrderPlacePageState createState() => _OrderPlacePageState();
}

class _OrderPlacePageState extends State<OrderPlacePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image(
                      image: AssetImage("assets/Ic_thank_you.png"),
                      width: 300,
                    ),
                  ),
                ),
                flex: 5,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: <Widget>[
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Đơn hàng được khởi tạo thành công!\n"
                                  "Đơn hàng của quý khách đang trong quá trình xử lí. Cám ơn quý khách đã mua sắm tại DouBH.",
                              style: CustomTextStyle.textFormFieldMedium
                                  .copyWith(fontSize: 12, color: Colors.grey),
                            )
                          ])),
                      SizedBox(
                        height: 24,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => OrderSuccessScreen()));
                        },
                        child: Text(
                          "Xem đơn hàng",
                          style: CustomTextStyle.textFormFieldMedium
                              .copyWith(color: Colors.white),
                        ),
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                      )
                    ],
                  ),
                ),
                flex: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
