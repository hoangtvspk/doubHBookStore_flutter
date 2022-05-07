import 'package:carousel_slider/carousel_slider.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail/bookDetailController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../httpClient/config.dart';
import '../../model/bookModel.dart';
import '../../themes/light_color.dart';
import '../../themes/theme.dart';
import '../../widgets/title_text.dart';
import '../cart/cartControllerr.dart';

class BookDetail extends StatefulWidget {
  BookDetail({Key? key}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> with TickerProviderStateMixin {
  final _controller = Get.put(CartController());
  final BookDetailController c = Get.put(BookDetailController());
  late AnimationController controller;
  late Animation<double> animation;
  var formatter = NumberFormat('#,###,000');

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
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
  void cancelLoading() async {
    context.loaderOverlay.hide();
  }

  void onProgressing(var data, bookList) {
    // List<dynamic> responseJson = json.decode(utf8.decode(data.bodyBytes));
    // for (var e in responseJson) {
    //   Book book = new Book();
    //   book.id = e["id"];
    //   book.name = e["nameBook"];
    //   book.author = e["author"];
    //   book.category = e["category"]["nameCategory"];
    //   book.image = e["bookImages"][0]["image"].toString();
    //   book.price = e["price"];
    //   bookList.add(book);
    // }
  }

  Future<Book> getBooks() async {
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

    Book? book;
    await http
        .get(
            Uri.parse(Config.HTTP_CONFIG["baseURL"]! + Config.APP_API["book"]!))
        .then((value) => onProgressing(value, book))
        .whenComplete(() => cancelLoading());
    return book!;
  }

  final List<String> bannerList = [
    "https://www.nxbtre.com.vn/Images/Book/nxbtre_full_02162019_031655.jpg",
    "https://www.teahub.io/photos/full/55-550023_wallpaper-book-garland-light-darkness-reading-dark-books.jpg",
    "https://c4.wallpaperflare.com/wallpaper/129/868/891/book-of-life-wallpaper-preview.jpg",
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Free-Desktop-Book-Wallpapers-HD.jpg",
    "https://images5.alphacoders.com/443/443740.jpg",
    "https://www.heat-up.mx/wp-content/uploads/2014/10/book-table-close-up-photo-wallpaper-1680x1050.jpg",
  ];

  Widget _bookImage() {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: CarouselSlider(
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
        ));
  }

  Widget _detailWidget() {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
    print(agrs);

    // print(book);
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
                    onPressed: () => c.increment(agrs.book.quantity, context),
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

  @override
  Widget build(BuildContext context) {
    final BookDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            _bookImage(),
            _detailWidget()
          ],
        ),
      )),
      bottomNavigationBar: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20,right: 20),
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
                    padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10),
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
