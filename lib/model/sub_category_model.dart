class Sub_Category_model{
  final String sub_category;
  final int sub_category_ID;
  final double Sales;
  final int Booked;
  final String Executed;
  final String Execution;
  final int UnqCust;

  Sub_Category_model({
    required this.sub_category,
    required this.sub_category_ID,
    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory Sub_Category_model.fromJson(Map<String, dynamic> json) {
    return Sub_Category_model(
      sub_category: json['Product_SubCategory_Name'] ?? '',
      sub_category_ID: json['Product_SubCategory_Code'] ?? '',
      Sales: json['Sales_Inc_ST'] ?? 0.0,
      Booked: (json['Qty_Supplied'] ?? 0).toInt(),
      Executed: json['Executed'] ?? '',
      Execution: json['Execution_%_(Mean)'] ?? '',
      UnqCust: (json['Unique_Customers'] ?? 0.0).toInt(),
    );
  }
}