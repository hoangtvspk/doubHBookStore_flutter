import 'package:doubhBookstore_flutter_springboot/src/pages/books.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/cart.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/extentions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'home.dart';

class MainLayout extends StatefulWidget {
  MainLayout({Key? key,  this.title}) : super(key: key);

  final String? title;

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isHomePageSelected = true;
  bool isBooksPageSelected = false;
  bool isCartPageSelected = false;
  bool isProfilePageSelected = false;



  void onBottomIconPressed(int index) {
    if (index == 0) {
      setState(() {
        isHomePageSelected = true;
        isBooksPageSelected = false;
        isCartPageSelected = false;
        isProfilePageSelected = false;
      });
    } else if (index == 1) {
      setState(() {
        isHomePageSelected = false;
        isBooksPageSelected = true;
        isCartPageSelected = false;
        isProfilePageSelected = false;
      });
    } else if (index == 2) {
      setState(() {
        isHomePageSelected = false;
        isBooksPageSelected = false;
        isCartPageSelected = true;
        isProfilePageSelected = false;
      });
    } else {
      setState(() {
        isHomePageSelected = false;
        isBooksPageSelected = false;
        isCartPageSelected = false;
        isProfilePageSelected = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return  LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: SpinKitCubeGrid(
          color: Colors.red,
          size: 50.0,
        ),
      ),
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: AppTheme.fullHeight(context)-100 ,
                  color: Color(0xFFBDBDBD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          switchInCurve: Curves.easeInToLinear,
                          switchOutCurve: Curves.easeOutBack,
                          child: isHomePageSelected
                              ? HomePage()
                              : Align(
                              alignment: Alignment.topCenter,
                              child: isBooksPageSelected
                                  ? BooksPage()
                                  : Align(
                                alignment: Alignment.topCenter,
                                child: isCartPageSelected
                                  ?Cart()
                                  :ProfilePage(),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomBottomNavigationBar(
                  onIconPresedCallback: onBottomIconPressed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
