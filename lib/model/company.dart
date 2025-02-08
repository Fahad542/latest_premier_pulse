class CompanyanalysisData {

  final Set<String> empCodes;
  final String sales;
  final String name;
  final String designation;
  final String Execution;
  final String UnqCust;

  CompanyanalysisData({required this.empCodes, required this.sales, required this.name, required this.designation, required this.Execution, required this.UnqCust } );

  factory CompanyanalysisData.fromJson(Map<String, dynamic> json) {
    final dynamic empCodeData = json['EmpCode'];
    Set<String> empCodes = {};


    if (empCodeData is String) {
      empCodes = {for (var code in empCodeData.split(',')) code.trim()};
    } else if (empCodeData is List) {
      empCodes = Set<String>.from(empCodeData.map((empCode) => empCode.toString()));
    }


    return CompanyanalysisData(
        empCodes: empCodes,
        sales: json['Sales'] ?? '',
        name: json['Employee'] ?? '',
        designation: json['Designation'] ?? '',
        Execution: json['Execution'] ??'',
        UnqCust: json['UnqCust']
    );
  }
}