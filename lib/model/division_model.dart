class Division_model{
  final String division;
  final int division_ID;
  final double Sales;
  final double Booked;
  final String Executed;
  final String Execution;
  final double UnqCust;

  Division_model({
    required this.division,
    required this.division_ID,
    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory Division_model.fromJson(Map<String, dynamic> json) {
    return Division_model(
      division: json['Product_Brand_Name'] ?? '',
      division_ID: json['Product_Brand_Code'] ?? '',
      Sales: json['Sales_Inc_ST'] ?? 0.0,
      Booked: json['Qty_Supplied'] ?? 0,
      Executed: json['Executed'] ?? '',
      Execution: json['Execution_%_(Mean)'] ?? "0",
      UnqCust: json['Unique_Customers'] ?? 0,
    );
  }
}