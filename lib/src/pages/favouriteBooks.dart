import 'dart:async';
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/reviewModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/userModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/Search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class FavouriteBooks extends StatefulWidget {
  FavouriteBooks({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FavouriteBooksState createState() => _FavouriteBooksState();
}

class _FavouriteBooksState extends State<FavouriteBooks> {
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
    final box = GetStorage();
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

    List<Book> bookList = [];
    await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + "/users/lovedbook"),
        headers: Config.HEADER)
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
  late Future<List<Book>> bookList = getBooks(cateSearch,moneySearch);
  loadPage(){
    setState(() {
      bookList = getBooks(cateSearch,moneySearch);
    });
  }
  FutureOr onChange(dynamic value) {
    loadPage();
    setState(() {});
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
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Container(child: Center(child: Text("Chưa có sản phẩm yêu thích nào")));
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
                          BookDetailsArguments(book: snapshot.data[index])).then((value) => onChange(value));
                    },
                  );
                }),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sách yêu thích"),
          centerTitle: true,

        ),
        body: SingleChildScrollView(
          child: _bookList(),
        ));
  }
}