import 'dart:async';
import 'dart:convert';
import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/reviewModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/categoryModel.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/bookCard.dart';
import '../bookDetail/bookDetail.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, this.SearhKey}) : super(key: key);

  final String? SearhKey;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {

    super.initState();
  }
  double bookListHeight = 2000;
  final TextEditingController searchController = TextEditingController();
  void cancelLoading()async
  {
    context.loaderOverlay.hide();
  }
  void onProgressing(var data, bookList){
    print(data.body);
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [] ;
      for (int i =0;i<e["bookImages"].length;i++){
        imageList.add(ImageModel(id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      List<ReviewModel> reviewList = [] ;
      for (int i =0;i<e["reviews"].length;i++){
        reviewList.add(ReviewModel(id: e["reviews"][i]["id"], user: UserModel(id:e["reviews"][i]["user"]["id"] , email: e["reviews"][i]["user"]["email"], firstName: e["reviews"][i]["user"]["firstName"], lastName: e["reviews"][i]["user"]["lastName"]) , date: e["reviews"][i]["date"], message: e["reviews"][i]["message"], rating: e["reviews"][i]["rating"]));
      }
      print(e["reviews"]);
      Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"]
          ,category: CategoryModel(id: e["category"]["id"],nameCategory: e["category"]["nameCategory"])
          ,image: imageList,price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false
          , detail: e["detail"], rating: e["rating"] , review: reviewList);

      bookList.add(book);
    }

  }

  Future<List<Book>> getBooks() async {
    String search2 = json.encode({
      "idCategory":"",
      "keyWord":searchController.text,
      "minPrice": "",
      "maxPrice": ""
    });
    List<Book> bookList = [];
    await http
        .post(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["booksSearch"]!),
        headers: <String, String>{"Content-Type": "application/json"},
            body:search2)
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading());
    return bookList;
  }

  Widget _search() {
    return Container(
      padding: const EdgeInsets.only(right: 50),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: searchController,
                onChanged: (text){
                  setState(() {});
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Bạn tìm sách gì hôm nay...",
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding:
                    EdgeInsets.only(left: 10, right: 10, top: 5),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _search(),
          centerTitle: true,

    ),
    body: SingleChildScrollView(
      child: _bookList(),
    ));
  }
}
