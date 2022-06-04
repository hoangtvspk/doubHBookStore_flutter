import 'dart:async';
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/reviewModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/userModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/books/Search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/categoryModel.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/bookCard.dart';
import '../bookDetail/bookDetail.dart';

class BooksPage extends StatefulWidget {
  BooksPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  double bookListHeight = 2000;
  bool cateSearch = false;
  bool moneySearch = false;

  get newlist => null;
  String categoryValue = "0";
  String priceValue = 'Tất cả';

  void cancelLoading() async {
    context.loaderOverlay.hide();
  }

  void onProgressing(var data, bookList) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [];
      for (int i = 0; i < e["bookImages"].length; i++) {
        imageList.add(ImageModel(
            id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      List<ReviewModel> reviewList = [];
      for (int i = 0; i < e["reviews"].length; i++) {
        reviewList.add(ReviewModel(
            id: e["reviews"][i]["id"],
            user: UserModel(
                id: e["reviews"][i]["user"]["id"],
                email: e["reviews"][i]["user"]["email"],
                firstName: e["reviews"][i]["user"]["firstName"],
                lastName: e["reviews"][i]["user"]["lastName"]),
            date: e["reviews"][i]["date"],
            message: e["reviews"][i]["message"],
            rating: e["reviews"][i]["rating"]));
      }
      Book book = new Book(
          id: e["id"],
          name: e["nameBook"],
          author: e["author"],
          category: CategoryModel(
              id: e["category"]["id"],
              nameCategory: e["category"]["nameCategory"]),
          image: imageList,
          price: e["price"],
          sale: e["discount"],
          quantity: e["quantity"],
          isSelected: false,
          detail: e["detail"],
          rating: e["rating"],
          review: reviewList);

      bookList.add(book);
    }
  }

  List<Book> books = [];

  Future<List<Book>> getBooks(bool cateSearch, bool moneySearch) async {
    context.loaderOverlay.show(
        widget: Center(
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
    String minPrice = "";
    String maxPrice = "";

    if(moneySearch == true){
      switch(priceValue){
        case '0-50.000':
          minPrice = '0';
          maxPrice = '50000';
          break;
        case '50.000-70.000':
          minPrice = '50000';
          maxPrice = '70000';
          break;
        case '70.000-100.000':
          minPrice = '70000';
          maxPrice = '100000';
          break;
        case '100.000-150.000':
          minPrice = '100000';
          maxPrice = '150000';
          break;
        case '>150.000':
          minPrice = '150000';
          maxPrice = '1000000';
          break;
      }

    }
    else{
      minPrice = "";
      maxPrice = "";
    }
    if (cateSearch == true) {

      String search2 = json.encode({
        "idCategory": categoryValue,
        "keyWord": "",
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      });
      List<Book> bookList = [];
      await http
          .post(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["booksSearch"]!),
          headers: <String, String>{"Content-Type": "application/json"},
          body: search2)
          .then((value) => onGetCateProgressing(value, bookList))
          .whenComplete(() => cancelLoading());
      return bookList;
    }else{
      String search2 = json.encode({
        "idCategory": "",
        "keyWord": "",
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      });
      List<Book> bookList = [];
      await http
          .post(
          Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
              Config.APP_API["booksSearch"]!),
          headers: <String, String>{"Content-Type": "application/json"},
          body: search2)
          .then((value) => onGetCateProgressing(value, bookList))
          .whenComplete(() => cancelLoading());
      return bookList;
    }
  }

  void onGetCateProgressing(var data, bookList) {
    print(data.body);
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [];
      for (int i = 0; i < e["bookImages"].length; i++) {
        imageList.add(ImageModel(
            id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      List<ReviewModel> reviewList = [];
      for (int i = 0; i < e["reviews"].length; i++) {
        reviewList.add(ReviewModel(
            id: e["reviews"][i]["id"],
            user: UserModel(
                id: e["reviews"][i]["user"]["id"],
                email: e["reviews"][i]["user"]["email"],
                firstName: e["reviews"][i]["user"]["firstName"],
                lastName: e["reviews"][i]["user"]["lastName"]),
            date: e["reviews"][i]["date"],
            message: e["reviews"][i]["message"],
            rating: e["reviews"][i]["rating"]));
      }
      print(e["reviews"]);
      Book book = new Book(
          id: e["id"],
          name: e["nameBook"],
          author: e["author"],
          category: CategoryModel(
              id: e["category"]["id"],
              nameCategory: e["category"]["nameCategory"]),
          image: imageList,
          price: e["price"],
          sale: e["discount"],
          quantity: e["quantity"],
          isSelected: false,
          detail: e["detail"],
          rating: e["rating"],
          review: reviewList);

      bookList.add(book);
    }
  }

  Future<List<Book>> getCateBooks() async {
    String search2 = json.encode({
      "idCategory": categoryValue,
      "keyWord": "",
      "minPrice": "",
      "maxPrice": ""
    });
    List<Book> bookList = [];
    await http
        .post(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
            Config.APP_API["booksSearch"]!),
        headers: <String, String>{"Content-Type": "application/json"},
        body: search2)
        .then((value) => onGetCateProgressing(value, bookList))
        .whenComplete(() => cancelLoading());
    setState(() {
      books = bookList;
    });
    return bookList;
  }

  Future<List<CategoryModel>> getCategories() async {
    context.loaderOverlay.show(
        widget: Center(
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

    List<CategoryModel> categoriesList = [];
    await http
        .get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["categoryBooks"]!))
        .then((value) => onGetCategoriesProgressing(value, categoriesList))
        .whenComplete(() => cancelLoading());
    return categoriesList;
  }

  void onGetCategoriesProgressing(var data, categoriesList) {
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      CategoryModel categoryModel =
      new CategoryModel(id: e["id"], nameCategory: e["nameCategory"]);
      categoriesList.add(categoryModel);
    }
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
                onTap: () {
                  Get.to(() => SearchPage());
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Bạn tìm sách gì hôm nay...",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 18, top: 0),
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
        future: getBooks(cateSearch,moneySearch),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));
          } else {
            bookListHeight =
                AppTheme.fullWidth(context) * (snapshot.data.length / 2);
          }
          return Container(
            height: AppTheme.fullWidth(context) *
                (snapshot.data.length / 2) *
                15 /
                20 + AppTheme.fullWidth(context),
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
                      Navigator.pushNamed(context, '/detail',
                          arguments:
                          BookDetailsArguments(book: snapshot.data[index]));
                    },
                  );
                }),
          );
        },
      ),
    );
  }

  Widget _CateName(int id) {
    return FutureBuilder(
        future: getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Icon(Icons.error)));

          }
          String cateName = "Tất cả";
          //List<String> responseJson = json.decode(utf8.decode(snapshot.data));
          for (var e in snapshot.data as List<CategoryModel>) {
            if (e.id == id) cateName = e.nameCategory.toString();
          }

          return Text(cateName);
        });
  }

  Widget _bookCategories() {
    return Container(
        child: FutureBuilder(
            future: getCategories(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Icon(Icons.error)));
              } else {
                bookListHeight =
                    AppTheme.fullWidth(context) * (snapshot.data.length / 2);
              }
              List<String> category = ["0"];
              for (var e in snapshot.data as List<CategoryModel>) {
                category.add(e.id.toString());
              }
              print(category);
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
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 12),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue == "0") {
                                  setState(() {
                                    categoryValue = newValue!;
                                    cateSearch = false;
                                  });
                                } else {
                                  setState(() {
                                    categoryValue = newValue!;
                                    cateSearch = true;
                                  });
                                }
                              },
                              items: category.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: _CateName(int.parse(value)),
                                );
                              }).toList() as List<DropdownMenuItem<String>>?,
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
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 12),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue == "Tất cả") {
                                  setState(() {
                                    priceValue = newValue!;
                                    moneySearch = false;
                                  });
                                } else {
                                  setState(() {
                                    priceValue = newValue!;
                                    moneySearch = true;
                                  });
                                }
                              },
                              items: <String>[
                                'Tất cả',
                                '0-50.000',
                                '50.000-70.000',
                                '70.000-100.000',
                                '100.000-150.000',
                                '>150.000'
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
            }));
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