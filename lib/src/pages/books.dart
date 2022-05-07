import 'dart:async';
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../httpClient/config.dart';
import '../model/bookModel.dart';

import '../model/categoryModel.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/bookCard.dart';
import 'bookDetail/bookDetail.dart';

class BooksPage extends StatefulWidget {
  BooksPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  double bookListHeight = 2000;

  void cancelLoading()async
  {
    context.loaderOverlay.hide();
  }
  void onProgressing(var data, bookList){
    final box = GetStorage();
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [] ;
      for (int i =0;i<e["bookImages"].length;i++){
        imageList.add(ImageModel(id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"]
          ,category: CategoryModel(id: e["category"]["id"],nameCategory: e["category"]["nameCategory"])
          ,image: imageList,price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false
          , detail: e["detail"], rating: e["rating"] );

      bookList.add(book);
    }

  }

  Future<List<Book>> getBooks() async {
    context.loaderOverlay.show(widget: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Đang tải dữ liệu...',
          ),
        ],
      ),
    ));

    List<Book> bookList = [];
    await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["book"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading());
    return bookList;
  }

  Widget _appBar() {
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

  Widget _search() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Bạn tìm sách gì hôm nay...",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 18, top: 0),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookList() {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: AppTheme.fullWidth(context),
      //height: AppTheme.fullWidth(context) * 2,
      color: Colors.white,
      child: FutureBuilder(
        future: getBooks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));
          } else {
            bookListHeight =
                AppTheme.fullWidth(context) * (snapshot.data.length / 2);
          }
          return Container(
              height: AppTheme.fullWidth(context) * (snapshot.data.length / 2)*15/20,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 12 / 20,
                    ),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.fullWidth(context) * 0.05),
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    return BookCard.BookCard(
                      book: snapshot.data[index],
                      cardHeight: AppTheme.fullWidth(context),
                      cardWidth: AppTheme.fullWidth(context),
                      onSelected: (model) {
                        Navigator.pushNamed(context,'/detail', arguments:BookDetailsArguments(book:snapshot.data[index]));
                      },
                    );
                  }),
          );
        },
      ),
    );
  }

  String categoryValue = 'Tất cả';
  String priceValue = 'Tất cả';

  Widget _bookCategories() {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.start,
        scrollDirection: Axis.horizontal,
        child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Thể loại:",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: DropdownButton<String>(
                    value: categoryValue,
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        categoryValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Tất cả',
                      'Tiểu Thuyết',
                      'Trinh Thám',
                      'Cổ tích',
                      'Truyện Dài'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Giá:",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: DropdownButton<String>(
                    value: priceValue,
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        priceValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Tất cả',
                      '10.000-50.000',
                      '50.000-70.000',
                      '100.000-500.000'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ))
            ],
          ),
        ));
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
              background: _appBar(),
              title: _search(),
              centerTitle: true,
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.only(bottom: 10),
            ),
          )),
      SliverList(
          delegate: SliverChildListDelegate(<Widget>[
        _bookCategories(),
        _bookList(),
      ]))
    ]);
  }
}
