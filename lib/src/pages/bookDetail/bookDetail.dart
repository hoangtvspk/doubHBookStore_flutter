import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/reviewModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail/bookDetailController.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail/rating_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../model/categoryModel.dart';
import '../../model/imageModel.dart';
import '../../model/userLoginInfoModel.dart';
import '../../model/userModel.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/bookCardHome.dart';
import '../../widgets/flushBar.dart';
import '../../widgets/title_text.dart';
import '../cart/cartControllerr.dart';
import '../login/signInScreen.dart';

class BookDetail extends StatefulWidget {
  BookDetail({Key? key}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> with TickerProviderStateMixin {
  final _controller = Get.put(CartController());
  final BookDetailController c = Get.put(BookDetailController());

  late Animation<double> animation;
  var formatter = NumberFormat('#,###,000');
  double rating = 0.0;
  ScrollController _scrollController = ScrollController();
  bool isLove = false;
  final box = GetStorage();



  @override
  void initState() {
    super.initState();
    if (c.isChangeReview == 1) {
      c.isChangeReview = 0;
      WidgetsBinding.instance?.addPostFrameCallback((_) => changeWhenReview());
    }
    dynamic userInfo = (box.read("userInfo"));
    print(userInfo.toString());
  }

  List<BoxShadow> shadow = [
    BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   controller =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  //   animation = Tween<double>(begin: 0, end: 1).animate(
  //       CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
  //   controller.forward();
  // }
  //
  @override
  void dispose() {
    super.dispose();
  }

  void cancelLoading() async {
    // context.loaderOverlay.hide();
  }

  void onGetBookProgressing(var data, bookList) {
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

  Future<List<Book>> getBooks() async {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;

    List<Book> bookList = [];
    await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
            "/books/related-products/${agrs.book.category.id}"))
        .then((value) => onGetBookProgressing(value, bookList))
        .whenComplete(() => cancelLoading());


    return bookList;
  }

  Future<List<Book>> getLoveBooks() async {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    List<Book> bookList = [];
    await http
        .get(Uri.parse(Config.HTTP_CONFIG["baseURL"]! + "/users/lovedbook"),
            headers: Config.HEADER)
        .then((value) => onGetLoveBookProgressing(value, bookList))
        .whenComplete(() => cancelLoading());
    return bookList;
  }

  void onGetLoveBookProgressing(var data, bookList) {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
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
      if (agrs.book.id == book.id && c.isFavor == false) {
        setState(() {
          isLove = true;
        });
      }
      bookList.add(book);
    }
  }

  Future addToFavor() async {
    dynamic userInfo = (box.read("userInfo"));
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    if (userInfo == null) {
      Get.to(() => SignInPage());
    } else {
      await http
          .put(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
            "/users/lovedbook/add/" +
            agrs.book.id.toString()),
        headers: Config.HEADER,
      )
          .then((value) => onAddLoveBookProgressing(value))
          .whenComplete(() {});
    }
  }

  Future removeFavor() async {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    dynamic userInfo = (box.read("userInfo"));
    if (userInfo == null) {
      Get.to(() => SignInPage());
    } else {
      await http
          .delete(
        Uri.parse(Config.HTTP_CONFIG["baseURL"]! +
            "/users/lovedbook/remove/" +
            agrs.book.id.toString()),
        headers: Config.HEADER,
      )
          .then((value) => onRemoveLoveBookProgressing(value))
          .whenComplete(() {});
    }
  }

  void onAddLoveBookProgressing(var data) {
    setState(() {
      isLove = true;
    });
    c.isFavor.value = true;
    FlushBar.showFlushBar(
      context,
      null,
      "Đã Thêm Vào Yêu Thích",
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  void onRemoveLoveBookProgressing(var data) {
    setState(() {
      isLove = false;
    });
    c.isFavor.value = false;
    FlushBar.showFlushBar(
      context,
      null,
      "Đã Xóa Khỏi Yêu Thích",
      Icon(
        Icons.delete_outlined,
        color: Colors.red,
      ),
    );
  }

  Widget _relatedBookWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .63,
      color: Colors.white,
      child: FutureBuilder(
        future: getBooks(),
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
                    Navigator.pushNamed(context, '/detail',
                        arguments:
                            BookDetailsArguments(book: snapshot.data[index]));
                  },
                );
              });
        },
      ),
    );
  }

  Widget _lovedBookWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          child: TitleText(
            text: "Sách bạn yêu thích:",
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          width: AppTheme.fullWidth(context),
          height: AppTheme.fullWidth(context) * .63,
          color: Colors.white,
          child: FutureBuilder(
            future: getLoveBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null || snapshot.data.length == 0) {
                return Container(child: Center(child: Text("Chưa có sản phẩm nào!")));
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
                        Navigator.pushNamed(context, '/detail',
                            arguments: BookDetailsArguments(
                                book: snapshot.data[index]));
                      },
                    );
                  });
            },
          ),
        )
      ],
    );
  }

  Widget _bookImage() {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: true,
                height: AppTheme.fullWidth(context),
              ),
              items: agrs.book.image
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.network(
                              e.image,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ));
  }

  Widget _detailWidget() {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;

    return Container(
      padding: AppTheme.padding.copyWith(bottom: 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 5),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: LightColor.iconColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(height: 10),
            (agrs == null)
                ? Container(child: Center(child: Icon(Icons.error)))
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          agrs.book.name,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'Tahoma'),
                        ),
                        RatingBarIndicator(
                          rating: agrs.book.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          "Thể loại: " + agrs.book.category.nameCategory,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontFamily: 'Arial'),
                        ),
                        Text(
                          "Tác giả: " + agrs.book.author,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontFamily: 'Arial'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (agrs.book.sale != null && agrs.book.sale != 0)
                            ? Row(
                                children: [
                                  TitleText(
                                    text:
                                        "${formatter.format(agrs.book.price - agrs.book.price * agrs.book.sale / 100).toString()}₫",
                                    fontSize: 25,
                                    color: Colors.black87,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.deepOrange),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white54,
                                      ),
                                      child: Text(
                                        "-${agrs.book.sale.toString()} %",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "${formatter.format(agrs.book.price).toString()}₫",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Row(children: [
                                TitleText(
                                  text:
                                      "${formatter.format(agrs.book.price).toString()}₫",
                                  fontSize: 25,
                                  color: Colors.black87,
                                ),
                              ])
                      ],
                    ),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: new IconButton(
                    onPressed: () => c.decrement(agrs.book.quantity, context),
                    icon: new Icon(Icons.remove, size: 24),
                    color: Colors.grey.shade700,
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.only(bottom: 2, right: 12, left: 12),
                    child: Obx(
                      () => Text(
                        "${c.count}",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: new IconButton(
                    onPressed: () => {
                      c.increment(agrs.book.quantity, context),
                    },
                    icon: new Icon(Icons.add, size: 24),
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                TitleText(
                  text: "Còn ${agrs.book.quantity} cuốn",
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _description(),
            Divider(),
            TitleText(
              text: "Sách liên quan:",
              fontSize: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _description() {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Mô tả",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text(agrs.book.detail),
      ],
    );
  }

  // late Future<List<Address>> addressesList = c.getAddress(context);
  // loadPage(){
  //   setState(() {
  //     addressesList = c.getAddress(context);
  //   });
  // }
  FutureOr onChange(dynamic value) {
    setState(() {});
  }

  FutureOr onChange1(dynamic value) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/detail',
            arguments: BookDetailsArguments(book: c.book))
        .then((value) => changeWhenReview());
  }

  void changeWhenReview() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    List<ReviewModel> reviewList = [];
    for (int i = 0; i < agrs.book.review.length; i++) {
      reviewList.add(ReviewModel(
          id: agrs.book.review[i].id,
          user: agrs.book.review[i].user,
          date: agrs.book.review[i].date,
          message: agrs.book.review[i].message,
          rating: agrs.book.review[i].rating));
    }
    dynamic userInfo = (box.read("userInfo"));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Container(
          padding: EdgeInsets.only(left: AppTheme.fullWidth(context) - 150),
          child: (isLove)
              ? IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Color(0xffFF8993),
                    size: 30,
                  ),
                  onPressed: () {
                    removeFavor();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: Color(0xffFF8993),
                    size: 30,
                  ),
                  onPressed: () {
                    addToFavor();
                  },
                ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                _bookImage(),
                _detailWidget(),
                _relatedBookWidget(),
                (userInfo != null)?_lovedBookWidget():SizedBox(),
                Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 72.0, vertical: 16.0),
                          child: Text(
                            'Đánh giá từ khách hàng',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 92,
                          width: 92,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(agrs.book.image[0].image),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              boxShadow: shadow,
                              border:
                                  Border.all(width: 8.0, color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '${num.parse(agrs.book.rating.toStringAsExponential(1))}',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                              Column(children: <Widget>[
                                RatingBarIndicator(
                                  rating: agrs.book.rating,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.favorite,
                                    color: Color(0xffFF8993),
                                  ),
                                  itemCount: 5,
                                  itemSize: 35.0,
                                  direction: Axis.horizontal,
                                ),
                              ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text('Phản hồi gần đây'),
                        ),
                        Column(
                          children: <Widget>[
                            ...reviewList
                                .map((val) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        //border: Border(bottom: BorderSide(color: Colors.grey, width: 0.1)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: CircleAvatar(
                                            maxRadius: 14,
                                            backgroundImage: AssetImage(
                                                'assets/chipheo.jpg'),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${val.user.lastName} ${val.user.firstName}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${val.date}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: RatingBarIndicator(
                                                  rating: val.rating.toDouble(),
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.favorite,
                                                    color: Color(0xffFF8993),
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 15.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              Text(
                                                '${val.message}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        )
                                      ],
                                    )))
                                .toList(),
                            Text(
                              "Để lại đánh giá",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.post_add,
                                color: Colors.blue,
                                size: 40,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: RatingDialog.RatingDialog(
                                          book: agrs.book),
                                    );
                                  },
                                ).then(onChange1);
                              },
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
      bottomNavigationBar: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: AppTheme.fullHeight(context) / 10,
            width: AppTheme.fullWidth(context),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 0.2, color: Colors.grey.shade400))),
            child: Row(
              children: [
                (agrs.book.sale != null && agrs.book.sale != 0)
                    ? Obx(() => TitleText(
                          text:
                              "${formatter.format((agrs.book.price - agrs.book.price * agrs.book.sale / 100) * c.count.value).toString()}₫",
                          fontSize: 25,
                          color: Colors.red.withOpacity(0.7),
                        ))
                    : Obx(() => TitleText(
                          text:
                              "${formatter.format(agrs.book.price * c.count.value).toString()}₫",
                          fontSize: 25,
                          color: Colors.black87,
                        )),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await _controller.addToCart(agrs.book.id, context, c.count);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent, // Color(0xffF05945),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Chọn mua",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookDetailsArguments {
  final Book book;

  // static const Book bookDef = const Book(id: 1,name: "g",category: "",price: 1,sale:20,quantity: 1,isSelected:  true,image: "g",author: "gg");
  BookDetailsArguments({required this.book});
}
