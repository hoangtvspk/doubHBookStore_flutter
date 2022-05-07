import 'package:doubhBookstore_flutter_springboot/src/model/address.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/myInfoModel.dart';

class CheckOut{
  final MyInfoModel myInfoModel;
  final List<Address> addresses;
  CheckOut({required this.myInfoModel, required this.addresses});
}