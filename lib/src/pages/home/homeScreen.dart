import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/categoryModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/components/appBar.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/components/banner.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/components/search.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';

import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/bookCardHome.dart';
import '../bookDetail/bookDetail.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.put(HomeController());
  Widget _title(var cont) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 25,bottom: 0.3),
        child:  Text(
          cont,
          style: TextStyle(

              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        ),

    );
  }

  Widget _bookWidget(Future<List<Book>> Function() getBook) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .63,
      color: Colors.white,
      child: FutureBuilder(
        future: getBook(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));
          }
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5 / 2.8,
              ),
              padding: EdgeInsets.only(left: 10),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return BookCard.BookCard(
                  book: snapshot.data[index],
                  cardWidth: AppTheme.fullWidth(context),
                  onSelected: (model) {
                    Navigator.pushNamed(context,'/detail', arguments:BookDetailsArguments(book:snapshot.data[index]));

                  },
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          expandedHeight: 100.0,
          actionsIconTheme: IconThemeData(opacity: 1.0),
          flexibleSpace: Container(
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/headerBackg.png"),
              fit: BoxFit.fill,
            )),
            child: FlexibleSpaceBar(
              background: AppBarHome(),
              title: Search(),
              centerTitle: true,
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.only(bottom: 10),
            ),
          )),
      SliverList(
          delegate: SliverChildListDelegate(<Widget>[
        HomeBanner(),
        _title("Sách mới cập nhật"),
        _bookWidget(() => _controller.getNewBooks(context)),
        _title("Sách bán chạy"),
        _bookWidget(() => _controller.getBestSaleBooks(context)),
        _title("Khuyến mãi"),
        _bookWidget(() => _controller.getBestDiscountBooks(context)),
      ]))
    ]);
  }
}
