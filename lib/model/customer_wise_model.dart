class Customer {
  final int customerID;
  final String customerName;
  final double sales;
  final String Execution;
  final double lat;
  final double long;
  final String phone;

  Customer({
    required this.customerID,
    required this.customerName,
    required this.sales,
    required this.Execution,
    required this.lat,
    required this.long,
    required this.phone
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json['CustCode'] ?? "",
      customerName: json['CustName'] ?? "",
      sales: json['Sale'] ?? 0.0,
      Execution: json['Execution'] ?? "",
      lat: json['Lat'] ?? 0.0,
      long: json['Long'] ?? 0.0,
      phone: json['Phone'] ?? "",
    );
  }
}
