import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/checkoutScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cartItem.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/title_text.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomTextStyle.dart';
import 'package:doubhBookstore_flutter_springboot/src/utils/CustomUtils.dart';

import 'cartControllerr.dart';

class Cart extends StatefulWidget {
  const Cart({List<CartItem>? items, Key? key}) : super(key: key);

  Widget _item(Book model) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(80),
                    child: Image.asset(model.image[0].image,
                        fit: BoxFit.contain, height: 90, width: 90),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: model.price.toString(),
                        fontSize: 14,
                      ),
                      TitleText(
                        text: ' \VNĐ ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.quantity}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: ' sản phẩm',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '155.000 VNĐ',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Tiếp tục',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  @override
  _CartState createState() => _CartState();

// @override
// Widget build(BuildContext context) {
//   return Container(
//     padding: AppTheme.padding,
//     child: SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           ListView(
//             children: <Widget>[
//               createHeader(),
//               createSubTitle(),
//               createCartList(),
//               footer(context)
//             ],
//           ),
//           Divider(
//             thickness: 1,
//             height: 30,
//           ),
//           _price(),
//           SizedBox(height: 30),
//           _submitButton(context),
//           SizedBox(height: 50),
//         ],
//       ),
//     ),
//   );
// }
}

class _CartState extends State<Cart> {
  final _controller = Get.put(CartController());
  final box = GetStorage();
  var formatter = NumberFormat('#,###,000');

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Tổng cộng",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  formatter.format(box.read("totalPrice")).toString(),
                  style: CustomTextStyle.textFormFieldBlack.copyWith(
                      color: Colors.greenAccent.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          Utils.getSizedBox(height: 8),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => CheckOutPage())); ////
            },
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Thanh Toán",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  // createHeader() {
  //   return Container(
  //     alignment: Alignment.topLeft,
  //     child: Text(
  //       "SHOPPING CART",
  //       style: CustomTextStyle.textFormFieldBold
  //           .copyWith(fontSize: 16, color: Colors.black),
  //     ),
  //     margin: EdgeInsets.only(left: 12, top: 12),
  //   );
  // }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Có(" + box.read("totalItem").toString() + ") sản phẩm",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList(Future<List<CartItem>> Function() getCartItem) {
    return FutureBuilder(
        future: getCartItem(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));
          }
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return createCartListItem(snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        });
  }

  createCartListItem(CartItem cartItem) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        image: NetworkImage(cartItem.book.image[0].image))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          cartItem.book.name.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      Utils.getSizedBox(height: 6),
                      Text(
                        cartItem.book.category.nameCategory.toString(),
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              formatter.format(cartItem.book.price).toString(),
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(color: Colors.green),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white54,
                              ),
                              child: Text(
                                "-${cartItem.book.sale.toString()} %",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: new IconButton(
                                      onPressed: () async { await _controller.removeOne(
                                          cartItem.book.id, cartItem.book);
                                      setState(() {});
                                      },
                                      icon: new Icon(Icons.remove, size: 24),
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      cartItem.quantity.toString(),
                                      style:
                                          CustomTextStyle.textFormFieldSemiBold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: new IconButton(
                                      onPressed: () async { await _controller.addOne(
                                            cartItem.book.id, cartItem.book);
                                        setState(() {});
                                      },
                                      icon: new Icon(Icons.add, size: 24),
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: new IconButton(
              onPressed: () async { await _controller.removeItem(
                  cartItem.book.id);
              setState(() {});
              },
              icon: new Icon(Icons.close, size: 15),
              color: Colors.white,
            ),
            // child: Icon(
            //   Icons.close,
            //   color: Colors.white,
            //   size: 20,
            // ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.green),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              createSubTitle(),
              createCartList(() async => await _controller.getCartItems(context)),
              footer(context)
            ],
          );
        },
      ),
    );
  }
}
