class CartItemRequest{
  int id;
  int quantity;

  CartItemRequest({required this.id, required this.quantity});
  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
  };
}