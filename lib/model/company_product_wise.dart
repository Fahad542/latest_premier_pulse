class ProductModel {
  //final String skuCode;
  final String sku;
  final double sales;

  ProductModel({
    //required this.skuCode,
    required this.sku,
    required this.sales,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      //skuCode: json['SKU_Code'] ?? '',
      sku: json['ProductName'] ?? '',
      sales: json['Sale'] ?? '',
    );
  }
}
