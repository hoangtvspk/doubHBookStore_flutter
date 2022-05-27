import 'package:doubhBookstore_flutter_springboot/src/checkout/checkoutController.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/checkout/checkoutScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/order.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/homeScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/myOrders/orderController.dart';
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


class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({List<CartItem>? items, Key? key}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();

}
class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _controller = Get.put(OrderController());

  final box = GetStorage();
  var formatter = NumberFormat('#,###,000');
  final prefs = SharedPreferences.getInstance();

  Widget orderInfo(){
    final OrderDetailsArguments agrs =
    ModalRoute.of(context)!.settings.arguments as OrderDetailsArguments;
    return Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          "Mã đơn hàng: 097gex1gaat392${agrs.order.id
                              .toString()}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          "Ngày đặt: ${agrs.order.date
                              .toString()}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          "Trạng thái: ${agrs.order.status
                              .toString()}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: Text(
                          "${agrs.order.orderItems.length
                              .toString()} sản phẩm:",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[

                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              bottom: 4, left: 5),
                          child: Text("Thành tiền: ",
                            style:TextStyle(
                                color: Colors.grey
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              bottom: 2, right: 5),
                          child: Text(agrs.order.totelPrice.toString()+"đ",
                            style:TextStyle(
                                color: Colors.redAccent,
                                fontSize: 22
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  createOrderItemList(Future<List<Order>> Function() getOrder) {
    final OrderDetailsArguments agrs =
    ModalRoute.of(context)!.settings.arguments as OrderDetailsArguments;

          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return createOrderItemListItem(agrs.order.orderItems[index]);
            },
            itemCount: agrs.order.orderItems.length,
          );

  }

  createOrderItemListItem(OrderItem orderItem) {
    return GestureDetector(
      child:
      Container(
          margin: EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5),width: 0.5))
          ),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.blue.shade200,
                        image: DecorationImage(
                            image: NetworkImage(orderItem.book.image[0].image),
                            fit: BoxFit.fill)),
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
                              orderItem.book.name.toString(),
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Utils.getSizedBox(height: 6),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white54,
                                      ),
                                      child: Text(
                                        "${orderItem.book.category.nameCategory
                                            .toString()}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[

                                      Container(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.only(
                                            bottom: 2, right: 5, left: 5),
                                        child: Text("x"+
                                            orderItem.quantity.toString(),
                                          style:TextStyle(
                                              color: Colors.grey
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),(orderItem.book.sale != null && orderItem.book.sale != "")?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Text(
                                "${formatter.format(orderItem.book.price -
                                    orderItem.book.price * orderItem.book.sale /
                                        100).toString()}₫",
                                style: CustomTextStyle.textFormFieldBlack
                                    .copyWith(color: Colors.redAccent),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left:5,right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                ),
                                child: Text(
                                  "${formatter.format(orderItem.book.price)
                                      .toString()}₫",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ):Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left:5,right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                ),
                                child: Text(
                                  "${formatter.format(orderItem.book.price)
                                      .toString()}₫",
                                  style: CustomTextStyle.textFormFieldBlack
                                      .copyWith(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),

            ],
          )
      ),
    );
  }

  @override
  void initState() {
    //print("before state");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isEmpty == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Chi tiết đơn hàng"),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        body: Builder(
          builder: (context) {
            return ListView(
              children: <Widget>[
                orderInfo(),
                createOrderItemList(
                        () async => await _controller.getUserOrder(context)),
              ],
            );
          },
        ),
      );
    } else {
      return emptyCart();
    }
  }

  Scaffold emptyCart() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
                child: Container(
                  color: Color(0xFFFFFFFF),
                ),
              ),
              Container(
                width: double.infinity,
                height: 250,
                child: Image.asset(
                  "assets/empty_shopping_cart.png",
                  height: 250,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 40,
                child: Container(
                  color: Color(0xFFFFFFFF),
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Bạn chưa có sản phẩm trong giỏ hàng",
                  style: TextStyle(
                    color: Color(0xFF67778E),
                    fontFamily: 'Roboto-Light.ttf',
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class OrderDetailsArguments {
  final Order order;

  // static const Book bookDef = const Book(id: 1,name: "g",category: "",price: 1,sale:20,quantity: 1,isSelected:  true,image: "g",author: "gg");
  OrderDetailsArguments({required this.order});
}