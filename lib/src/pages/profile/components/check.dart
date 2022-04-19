import 'package:shared_preferences/shared_preferences.dart';

class Check{
  Future<void> check(bool? isAuth) async{
    final prefs = await SharedPreferences.getInstance();
    isAuth = await prefs.getBool("isAuth");
  }
  bool isAuthh(isAuth){
    check(isAuth);
    print(isAuth);
    return isAuth;

}
}