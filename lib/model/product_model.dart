class Compnay_ProductModel {
  final String skuCode;
  final String sku;
  final double sales;

  Compnay_ProductModel({
    required this.skuCode,
    required this.sku,
    required this.sales,
  });

  factory Compnay_ProductModel.fromJson(Map<String, dynamic> json) {
    return Compnay_ProductModel(
      skuCode: json['SKU_Code'] ?? '',
      sku: json['ProductName'] ?? '',
      sales: json['Sale'] ?? '',
    );
  }
}