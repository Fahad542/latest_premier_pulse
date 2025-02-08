class division_type_model{
  final String Product_Class_Name;
  final double sales;

  division_type_model({
    required this.Product_Class_Name,
    required this.sales,
  });

  factory division_type_model.fromJson(Map<String, dynamic> json) {
    return division_type_model(
      Product_Class_Name: json['Product_Class_Name'] ?? '',
      sales: json['Sales_Inc_ST'] ?? 0.0,
    );
  }
}