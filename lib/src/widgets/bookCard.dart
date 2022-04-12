import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/extentions.dart';
import 'package:flutter/material.dart';

import '../themes/light_color.dart';
import "package:intl/intl.dart";

class BookCard extends StatelessWidget {
  final Book book;
  final ValueChanged<Book> onSelected;
  final double? cardHeight;
  final double? cardWidth;
  var formatter = NumberFormat('#,###,000');


  BookCard.BookCard({Key? key, required this.book, required this.onSelected,  this.cardHeight,  this.cardWidth })
      : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(20)),
        // border: Border.all(color: Colors.blueGrey,width: 0.02)
      ),
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.symmetric(
                            vertical: 2),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(book.image[0].image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 33,
                  child: (
                      Text(
                        book.name.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto-Light',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A4A4A),
                            fontSize: 14),
                      )
                  ),
                ),
                Text(
                  "₫"+ formatter.format(book.price).toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      color: Colors.redAccent,
                      fontSize: 15),
                ),

              ],
            ),
          ],
        ),
      ).ripple(() {
        onSelected(book);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
