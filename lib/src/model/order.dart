import 'bookModel.dart';

class Order {
  final int id;
  final String address;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final DateTime date;
  final double totelPrice;
  final String status;
  final List<OrderItem> orderItems;

  // Order(this.id, this.address, this.firstName, this.lastName, this.phoneNumber, this.email, this.date, this.totelPrice, this.status, this.orderItems);
  Order(
      {required this.id,
      required this.address,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.email,
      required this.date,
      required this.totelPrice,
      required this.status,
      required this.orderItems});
}

class OrderItem {
  final OrderItemID id;
  final int quantity;
  final Book book;

  OrderItem({required this.id, required this.quantity, required this.book});
}

class OrderItemID {
  final int orderId;
  final int bookId;

  OrderItemID({required this.orderId, required this.bookId});
}
