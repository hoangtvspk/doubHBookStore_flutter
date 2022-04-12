import 'package:doubhBookstore_flutter_springboot/src/pages/active.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/mainLayout.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/signUp.dart';
import 'package:flutter/material.dart';

import '../pages/signIn.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (context) => MainLayout(),
      '/detail':(context) => BookDetail(),
      '/home':(context) => HomePage(),
      '/signup':(context) => SignUpPage(),
      '/activation':(context)=> ActivationPage(),
      '/signin':(context)=>SignInPage(),
    };
  }
}
