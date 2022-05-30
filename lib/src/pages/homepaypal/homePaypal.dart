import 'package:flutter/material.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../checkout/checkoutController.dart';

class HomePaypal extends StatefulWidget {
  @override
  _HomePaypalState createState() => _HomePaypalState();
}

class _HomePaypalState extends State<HomePaypal> {
  final box = GetStorage();
  final _controller = Get.put(CheckoutController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Paypal"),
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
        body: Center(
            child: ElevatedButton(
          child: Text("Pay"),
          onPressed: () async {
            var request = BraintreeDropInRequest(
                tokenizationKey: "sandbox_38fq3fr3_jvbyb7ymfc5ktgft",
                collectDeviceData: true,
                paypalRequest: BraintreePayPalRequest(
                  amount:
                      (box.read("totalPrice")/ 23000).toString(),
                  //ten user
                  displayName: _controller.lastName.toString() +
                      " " +
                      _controller.firstName.toString(),
                ),
                cardEnabled: true);
            BraintreeDropInResult? result =
                await BraintreeDropIn.start(request);
            if (result != null) {
              print(result.paymentMethodNonce.description);
              print(result.paymentMethodNonce.nonce);
              print("if ne");
              await _controller.orderByPaypal(context);
            }
          },
        )));
  }
}
