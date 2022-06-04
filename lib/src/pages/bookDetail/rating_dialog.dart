import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'bookDetailController.dart';


class RatingDialog extends StatelessWidget {
  final BookDetailController c = Get.put(BookDetailController());
  final TextEditingController messageController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final Book book;
  RatingDialog.RatingDialog({required this.book});
  @override
  Widget build(BuildContext context) {
    const LinearGradient mainButton = LinearGradient(colors: [
      Color.fromRGBO(236, 60, 3, 1),
      Color.fromRGBO(234, 60, 3, 1),
      Color.fromRGBO(216, 78, 16, 1),
    ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);
    double width = MediaQuery.of(context).size.width;

    Widget onReview = InkWell(
      onTap: () async {
        await c.addReview(book.id, messageController.text, c.rate);
        Get.back();
      },
      child: Container(
        height: 60,
        width: width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Hoàn tất",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[50]),
          padding: EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RichText(
                text: TextSpan(
                    style:
                        TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Để lại đánh giá về ',
                      ),
                      TextSpan(
                          text: '${book.name.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
              ),
            ),
        RatingBar(
              itemSize: 32,
              allowHalfRating: false,
              initialRating: 1,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (value) {
                c.rating(value);
              },
              ratingWidget: RatingWidget(
                empty: Icon(Icons.favorite_border,
                    color: Color(0xffFF8993), size: 20),
                full: Icon(
                  Icons.favorite,
                  color: Color(0xffFF8993),
                  size: 20,
                ),
                half: SizedBox(),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Nói điều gì đó về sản phẩm...'),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLength: 200,
                )),
            onReview
          ])),
    );
  }
}
