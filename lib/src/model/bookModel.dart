// class Book{
//   int id;
//   String name ;
//   String category ;
//   // var image = [{}];
//   String image;
//   String price ;
//   int sale;
//   String author;
//   int quantity;
//   bool isliked ;
//   bool isSelected ;
//   Book({this.id,this.name, this.category, this.price, this.sale, this.quantity, this.isliked,this.isSelected = false,this.image, this.author});
// }
import 'dart:convert';

import 'package:doubhBookstore_flutter_springboot/src/model/categoryModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/imageModel.dart';
import 'package:doubhBookstore_flutter_springboot/src/model/reviewModel.dart';

Book employeeModelJson(String str) =>
    Book.fromJson(json.decode(str));

String employeeModelToJson(Book data) => json.encode(data.toJson());

class Book {
   final int id;
   final String name ;
   final CategoryModel category ;
   final List<ImageModel> image ;
   final int price ;
   final int sale;
   final String author;
  final int quantity;
  final bool isSelected ;
  final String detail;
  final double rating;
  final List<ReviewModel> review;

  const Book({required this.id,required this.name, required this.category, required this.price, required this.sale, required this.quantity,this.isSelected = false,required this.image, required this.author,required this.detail, required this.rating,required this.review});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      id: json["id"], name: json["name"], category: json["category"],
      image: json["image"],price: json["price"],sale: json["sale"],author: json["author"],quantity: json["quantity"],isSelected: json["isSelected"], detail: json["detail"], rating:json["rating"], review: json["review"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    'category': category,
    "image": image,
    "price": price,
    'sale': sale,
    'author': author,
    "quantity": quantity,
    "isSelected": isSelected,
  };
}
