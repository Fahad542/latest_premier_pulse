class Customer_compnay {
 // final int? customerID;
  final int? companyID;
  final String? companyName;
  final double sales;
  //final String Execution;

  Customer_compnay({
  //  this.customerID,
    this.companyID,
    this.companyName,
    required this.sales,
   // required this.Execution
  });

  factory Customer_compnay.fromJson(Map<String, dynamic> json) {
    return Customer_compnay(
    //  customerID: json['Customer_ID'] ?? '0',
      companyID: json['CompanyID'] ?? 0,
      companyName: json['CompanyName'] ?? 0,
      sales: json['Sale'] ?? 0.0,
      //Execution: json['Execution']??0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'Customer_ID': customerID,
      'CompanyID': companyID,
      'CompanyName': companyName,
      'Sale': sales,
    };
  }
}
