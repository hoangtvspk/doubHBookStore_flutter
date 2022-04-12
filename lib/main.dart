import 'package:doubhBookstore_flutter_springboot/src/config/route.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/active.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/signIn.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/mainLayout.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/signUp.dart';
import 'package:doubhBookstore_flutter_springboot/src/widgets/customRoute.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'src/themes/theme.dart';

void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cửa hàng sách DoubH',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      builder: EasyLoading.init(),

      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      onGenerateRoute: (RouteSettings settings) {

         return CustomRoute<bool>(
            builder: (BuildContext context) => MainLayout()
          );
      },
      initialRoute: "/",
    );
  }
}