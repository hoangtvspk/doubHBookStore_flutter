import 'package:doubhBookstore_flutter_springboot/src/model/userModel.dart';

class ReviewModel{
  final int id;
  final UserModel user;
  final String date;
  final String message;
  final double rating;
  ReviewModel({required this.id, required this.user, required this.date,required this.message, required this.rating});
}