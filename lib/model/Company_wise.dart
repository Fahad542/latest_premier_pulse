class Company {
  final int? companyId;
  final String? companyName;
  final double? sales;
  // final String Execution;
  // final String Uniq_Cust;

  Company({
    this.companyId,
    this.companyName,
    required this.sales,
    // required this.Execution,
    // required this.Uniq_Cust,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['CompanyID'],
      companyName: json['CompanyName'],
      sales: json['Sale'],
      // Execution: json['Execution'],
      // Uniq_Cust: json['Uniq._Cust.']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyId,
      'CompanyName': companyName,
      'Sale': sales,
    };
  }
}
