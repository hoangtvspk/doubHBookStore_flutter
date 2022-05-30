import 'package:doubhBookstore_flutter_springboot/src/checkout/checkoutController.dart';
import 'package:doubhBookstore_flutter_springboot/src/checkout/editPlaceOrderScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/checkoutInfo.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/myInfoModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addMyAddress/addMyAddressScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/cart/cartControllerr.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/orderPlaceScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/myProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';

import '../model/cartItem.dart';
import '../pages/homepaypal/homePaypal.dart';
import '../pages/mainLayout.dart';
import '../pages/myOrders/orderController.dart';
import '../pages/address/addressController.dart';
import '../pages/trackOrderScreen.dart';
import '../themes/theme.dart';
import '../utils/CustomUtils.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _controller = Get.put(CheckoutController());
  final _controller1 = Get.put(CartController());
  final _controller2 = Get.put(AddressController());
  var formatter = NumberFormat('#,###,000');
  final box = GetStorage();

  void onLoad() {
    _scaffoldKey.currentState?.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  Đang xử lí...")
        ],
      ),
    ));
    // _handleSignIn()
    //     .whenComplete(() =>
    //     Navigator.of(context).pushNamed("/Home")
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
          title: Text(
            "Đặt hàng",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Builder(builder: (context1) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      selectedAddressSection(),
                      // standardDelivery(),
                      checkoutItem(),
                      priceSection()
                    ],
                  ),
                ),
                flex: 90,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: RaisedButton(
                    onPressed: () async {

                      //thanh toan khi nhan hang
                      // onLoad();
                      // await _controller.order(context);
                      // Navigator.of(context).push(new MaterialPageRoute(
                      //     builder: (context) => OrderPlacePage())).then((val) {
                      //   Navigator.of(context).push(new MaterialPageRoute(
                      //       builder: (context) => MainLayout()));
                      // });

                      //thanh toan paypal
                      Navigator.of(context).push(new MaterialPageRoute(
                                 builder: (context) => HomePaypal()));
                    },
                    child: Text(
                      "Đặt hàng",
                      style: CustomTextStyle.textFormFieldMedium.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                  ),
                ),
                flex: 10,
              )
            ],
          );
        }),
      ),
    );
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
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
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\n\nThank you for your purchase. Our company values each and every customer. We strive to provide state-of-the-art devices that respond to our clients’ individual needs. If you have any questions or feedback, please don’t hesitate to reach out.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => ShowcaseDeliveryTimeline()));
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Track Order",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }

  selectedAddressSection() {
    return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.grey.shade200)),
            padding: EdgeInsets.only(left: 12, top: 8, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(() => Text(
                          _controller.lastName.string +
                              " " +
                              _controller.firstName.string,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        )),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Text(
                        "Mặc định",
                        style: CustomTextStyle.textFormFieldBlack.copyWith(
                            color: Colors.indigoAccent.shade200, fontSize: 8),
                      ),
                    )
                  ],
                ),
                Obx(() => createAddressText(
                    "Địa chỉ: " + _controller.address.string, 16)),
                Obx(() =>
                    createAddressText("Email: " + _controller.email.string, 6)),
                SizedBox(
                  height: 6,
                ),
                Obx(() => RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Số điện thoại : ",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 12, color: Colors.grey.shade800)),
                        TextSpan(
                            text: _controller.phoneNumber.string,
                            style: CustomTextStyle.textFormFieldBold
                                .copyWith(color: Colors.black, fontSize: 12)),
                      ]),
                    )),
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.grey.shade300,
                  height: 1,
                  width: double.infinity,
                ),
                addressAction()
              ],
            ),
          ),
        ));
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction() {
    return Container(
      child: Row(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          FlatButton(
            onPressed: () async {
              await _controller2.loadAddressForChoose(
                  context, _controller.selected);
              Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => EditPlaceOrderScreen()))
                  .then((val) {
                setState(() {});
              });
              // Get.to(() =>EditPlaceOrderScreen())!.then(null);
            },
            child: Text(
              "Thay đổi địa chỉ",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(fontSize: 12, color: Colors.indigo.shade700),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 3,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          Spacer(
            flex: 3,
          ),
          FlatButton(
            onPressed: () async {
              await _controller2.loadAddressForChoose(
                  context, _controller.selected);
              await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => AddMyAddressScreen()))
                  .then((val) {
                  _controller.updateUIAddress(_controller.selected);
                setState(() {});
              });
            },
            child: Text("Địa chỉ mới",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(fontSize: 12, color: Colors.indigo.shade700)),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Standard Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Get it by 20 jul - 27 jul | Free Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  checkoutItem() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: FutureBuilder(
              future: _controller1.getCartItems(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Icon(Icons.error)));
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return checkoutListItem(snapshot.data[index]);
                  },
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                );
              }),
        ),
      ),
    );
  }

  checkoutListItem(CartItem cartItem) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Container(
              child: Image(
                image: NetworkImage(cartItem.book.image[0].image),
                width: 35,
                height: 45,
                fit: BoxFit.fitHeight,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1)),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 8, top: 4, left: 0),
                    child: Text(
                      cartItem.book.name.toString(),
                      maxLines: 2,
                      softWrap: true,
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15),
                    ),
                  ),
                  Utils.getSizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    width: AppTheme.fullWidth(context) * 0.7,
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Số lượng: " + cartItem.quantity.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${formatter.format(cartItem.book.price - cartItem.book.price * cartItem.book.sale / 100).toString()}₫",
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(color: Colors.redAccent, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  priceSection() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              Text(
                "Chi tiết hóa đơn",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              createPriceItem(
                  "Giá trị đơn hàng",
                  formatter.format(box.read("totalPrice")).toString() + "₫",
                  Colors.grey.shade700),
              createPriceItem("Phí vận chuyển", "FREE", Colors.teal.shade300),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tổng cộng",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 15),
                  ),
                  Text(
                    formatter.format(box.read("totalPrice")).toString() + "₫",
                    style: CustomTextStyle.textFormFieldMedium
                        .copyWith(color: Colors.redAccent, fontSize: 15),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedCurrency(double amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount);
    fmf.settings!
      ..symbol = "₹"
      ..thousandSeparator = ","
      ..decimalSeparator = "."
      ..fractionDigits = 2;
    return fmf.output.symbolOnLeft;
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 13),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 13),
          )
        ],
      ),
    );
  }
}
