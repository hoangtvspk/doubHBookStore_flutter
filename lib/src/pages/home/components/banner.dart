import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  final List<String> bannerList = [
    "https://lh6.googleusercontent.com/eQHsVMxqSmtWfP7FYChVaLl-14JSYyFmPHY06ZLDUrgeUNlhNUCNQa73Wd4MmajGgpuZBtg05FLsF5tZ8ouwykcKV8Tf4lk1_IhOLblJCg6uRa-qFSaYglH0Jc2iilspuoGPMV9eKL_sIQVpKA",
    "https://theki.vn/wp-content/uploads/2019/05/trinh-bay-vai-tro-cua-sach-va-cach-doc-sach-dung-dan-qua-cau-noi-cua-m-gorki-hay-yeu-sach-no-la-nguon-tri-thuc.jpg",
    "https://www.thecoth.com/Uploads/images/lg_danh-ngon-ve-sach_10564.jpg",
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