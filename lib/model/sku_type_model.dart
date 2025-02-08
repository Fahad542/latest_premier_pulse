class sku_model{
  final String SKU_Type;
  final double Sales;
  final double Booked;
  final String Executed;
  final String Execution;
  final double UnqCust;
  sku_model({
    required this.SKU_Type,
    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory sku_model.fromJson(Map<String, dynamic> json) {
    return sku_model(
      SKU_Type: json['Product_Product_Name'] ?? '',
      Sales: json['Sales_Inc_ST'] ?? 0.0,
      Booked: json['Qty_Supplied'] ?? 0,
      Executed: json['Executed'] ?? '',
      Execution: json['Execution_%_(Mean)'] ?? "0",
      UnqCust: json['Unique_Customers'] ?? 0,
    );
  }
}