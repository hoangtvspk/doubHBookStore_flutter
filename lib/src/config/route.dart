import 'package:doubhBookstore_flutter_springboot/src/pages/register/active.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/homeScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/mainLayout.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/login/signInScreen.dart';
import '../pages/profile/myProfile/myProfileScreen.dart';


routes() => [
  GetPage(name: "/", page: () => MainLayout()),
  GetPage(name: "/detail", page: () => BookDetail()),
  GetPage(name: "/home", page: () => HomePage()),
  GetPage(name: "/signup", page: () => SignUpPage()),
  GetPage(name: "/activation", page: () => ActivationPage()),
  GetPage(name: "/signin", page: () => SignInPage()),
  GetPage(name: "/myProfile", page: () => MyProfileScreen()),
];