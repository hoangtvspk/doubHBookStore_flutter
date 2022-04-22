import 'package:doubhBookstore_flutter_springboot/src/model/bookModel.dart';

class CartItem{
  final CartItemID id;
  final int quantity;
  final Book book;
  CartItem({required this.id, required this.quantity, required this.book});
}

class CartItemID {
  final int orderId;
  final int bookId;
  CartItemID({ required this.orderId, required this.bookId});
}