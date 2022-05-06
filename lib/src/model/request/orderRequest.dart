class OrderRequest {
  String address;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;

  OrderRequest(
      {required this.address,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.email});

  Map<String, dynamic> toJson() => {
        "address": address,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}
