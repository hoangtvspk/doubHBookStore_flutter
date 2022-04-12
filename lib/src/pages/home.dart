import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/categoryModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/title_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../httpClient/config.dart';
import '../model/bookModel.dart';

import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/bookCardHome.dart';
import 'bookDetail.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void cancelLoading()async
  {
    context.loaderOverlay.hide();
  }
  void onProgressing(var data, bookList){
    List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    for (var e in responseJson) {
      List<ImageModel> imageList = [] ;
      for (int i =0;i<e["bookImages"].length;i++){
        imageList.add(ImageModel(id: e["bookImages"][i]["id"], image: e["bookImages"][i]["image"]));
      }
      Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"] ,category: CategoryModel(id: e["category"]["id"],nameCategory: e["category"]["nameCategory"]),image: imageList,price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false,detail: e["detail"],rating: e["rating"] );

      bookList.add(book);
    }

  }
  Future<List<Book>> getNewBooks() async {
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
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["newBook"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading());

    return bookList;
  }

  Future<List<Book>> getBestSaleBooks() async {
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
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["bestSellingBook"]!))
        .then((value) => onProgressing(value, bookList))
        .whenComplete(() => cancelLoading());
    // List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    // // for (var e in responseJson) {
    // //   Book book = new Book(id:e["id"],name: e["nameBook"],author:e["author"] ,category: e["category"]["nameCategory"],image: e["bookImages"][0]["image"].toString(),price:e["price"] ,sale: e["discount"],quantity: e["quantity"],isSelected: false );
    // //   // book.id = e["id"];
    // //   // book.name = e["nameBook"];
    // //   // book.author = e["author"];
    // //   // book.category = e["category"]["nameCategory"];
    // //   // book.image = e["bookImages"][0]["image"].toString();
    // //   // book.price = e["price"];
    // //   // book.sale = e["discount"];
    // //   bookList.add(book);
    // }

    return bookList;
  }

  Future<List<Book>> getBestDiscountBooks() async {
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
    await http.get(Uri.parse(
        Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["bestDiscountBook"]!))
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

  final List<String> bannerList = [
    "https://www.teahub.io/photos/full/55-550023_wallpaper-book-garland-light-darkness-reading-dark-books.jpg",
    "https://i.pinimg.com/originals/b7/23/cb/b723cb289b80267278b606991e238c05.jpg",
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Free-Desktop-Book-Wallpapers-HD.jpg",
    "https://images5.alphacoders.com/443/443740.jpg",
    "https://www.heat-up.mx/wp-content/uploads/2014/10/book-table-close-up-photo-wallpaper-1680x1050.jpg",
  ];

  Widget _banner() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/bannerBackg.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter)),
        padding: const EdgeInsets.only(top: 10),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: true,
            height: 160,
          ),
          items: bannerList
              .map((e) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.network(
                          e,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ))
              .toList(),
        ));
  }

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
              background: _appBar(),
              title: _search(),
              centerTitle: true,
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.only(bottom: 10),
            ),
          )),
      SliverList(
          delegate: SliverChildListDelegate(<Widget>[
        _banner(),
        _title("Sách mới cập nhật"),
        _bookWidget(getNewBooks),
        _title("Sách bán chạy"),
        _bookWidget(getBestSaleBooks),
        _title("Khuyến mãi"),
        _bookWidget(getBestDiscountBooks),
      ]))
    ]);
  }
}
