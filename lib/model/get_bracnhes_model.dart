class get_bracnhes_model{
  final String Branch;
  final String Branch_Code;
  final String Sales;
  final String Booked;
  final String Executed;
  final String Execution;
  final String UnqCust;

  get_bracnhes_model({
    required this.Branch,
    required this.Branch_Code,
    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory get_bracnhes_model.fromJson(Map<String, dynamic> json) {
    return get_bracnhes_model(
      Branch: json['Branch_Branch_Report_Name'] ?? '',
      Branch_Code: json['Branch_Code'] ?? '',
      Sales: json['Sales'] ?? '',
      Booked: json['Booked'] ?? '',
      Executed: json['Executed'] ?? '',
      Execution: json['Execution'] ?? '',
      UnqCust: json['UnqCust'] ?? '',
    );
  }
}




class get_bracnhes_model_info{
  final String Branch;
  final String Branch_Code;


  get_bracnhes_model_info({
    required this.Branch,
    required this.Branch_Code,

  });

  factory get_bracnhes_model_info.fromJson(Map<String, dynamic> json) {
    return get_bracnhes_model_info(
      Branch: json['Branch_Branch_Report_Name'] ?? '',
      Branch_Code: json['Branch_Branch_Code'] ?? '',

    );
  }
}