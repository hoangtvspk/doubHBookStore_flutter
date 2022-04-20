import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  final List<String> bannerList = [
    "https://www.teahub.io/photos/full/55-550023_wallpaper-book-garland-light-darkness-reading-dark-books.jpg",
    "https://i.pinimg.com/originals/b7/23/cb/b723cb289b80267278b606991e238c05.jpg",
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Free-Desktop-Book-Wallpapers-HD.jpg",
    "https://images5.alphacoders.com/443/443740.jpg",
    "https://www.heat-up.mx/wp-content/uploads/2014/10/book-table-close-up-photo-wallpaper-1680x1050.jpg",
  ];
  @override
  Widget build(BuildContext context) {
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
}