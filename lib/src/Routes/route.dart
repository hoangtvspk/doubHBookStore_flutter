import 'package:doubhBookstore_flutter_springboot/src/pages/Search.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addMyAddress/addMyAddressScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/address/addressScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/myOrders/orderDetailScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/myOrders/orderScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/profile/myProfile/editPassword/editPasswordScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/register/active.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/bookDetail/bookDetail.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/home/homeScreen.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/mainLayout.dart';
import 'package:doubhBookstore_flutter_springboot/src/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/address/editMyAddress/editMyAddressScreen.dart';
import '../pages/login/signInScreen.dart';
import '../pages/profile/myProfile/editMyProfile/editMyProfileScreen.dart';
import '../pages/profile/myProfile/myProfileScreen.dart';


routes() => [
  GetPage(name: "/", page: () => MainLayout()),
  GetPage(name: "/detail", page: () => BookDetail()),
  GetPage(name: "/home", page: () => HomePage()),
  GetPage(name: "/signup", page: () => SignUpPage()),
  GetPage(name: "/activation", page: () => ActivationPage()),
  GetPage(name: "/signin", page: () => SignInPage()),
  GetPage(name: "/myProfile", page: () => MyProfileScreen()),
  GetPage(name: "/editProfile", page: () => EditMyProfileScreen()),
  GetPage(name: "/editPassword", page: () => EditPasswordScreen()),
  GetPage(name: "/address",page: () => AddressScreen()),
  GetPage(name: "/editAddress",page: () => EditMyAddressScreen()),
  GetPage(name: "/addAddress",page: () => AddMyAddressScreen()),
  GetPage(name: "/search",page: () => SearchPage()),
  GetPage(name: "/myOrders",page: () => OrderScreen()),
  GetPage(name: "/orderDetail",page: () => OrderDetailScreen()),

];