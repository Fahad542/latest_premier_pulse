class Category_model
{

  final String category;
  final int category_ID;
  final double Sales;
  final int Booked;
  final String Executed;
  final String Execution;
  final int UnqCust;

  Category_model({
    required this.category,
    required this.category_ID,
    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory Category_model.fromJson(Map<String, dynamic> json) {
    return Category_model(
      category: json['Product_Category_Name'] ?? '',
      category_ID: json['Product_Category_Code'] ?? '',
      Sales: json['Sales_Inc_ST'] ?? 0.0,
      Booked: json['Qty_Supplied'] ?? 0,
      Executed: json['Executed'] ?? '',
      Execution: json['Execution_%_(Mean)'] ?? '',
      UnqCust: json['Unique_Customers'] ?? 0,
    );
  }

}