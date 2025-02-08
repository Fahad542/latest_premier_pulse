class SalesData {
  final Set<String> empCodes;
  final double sales;
  final String name;
  final String designation;
  final String Execution;
  final String UnqCust;

  SalesData({required this.empCodes, required this.sales, required this.name, required this.designation, required this.Execution, required this.UnqCust } );

  factory SalesData.fromJson(Map<String, dynamic> json) {
    final dynamic empCodeData = json['EmpCode'];
    Set<String> empCodes = {};


      if (empCodeData is String) {
        // Split the string into sub-strings and add them to the set
        empCodes = {for (var code in empCodeData.split(',')) code.trim()};
      } else if (empCodeData is List) {
        // Add each item in the list to the set
        empCodes =
        Set<String>.from(empCodeData.map((empCode) => empCode.toString()));
      }


    return SalesData(
      empCodes: empCodes,
      sales: json['Sales_Inc_ST'] ?? 0.0,
      name: json['EmpName'] ?? '',
      designation: json['EmpDesignation'] ?? '',
      Execution: json['Execution'] ??'',
      UnqCust: json['UnqCust'] ?? ""
    );
  }
}