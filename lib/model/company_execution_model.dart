class company_execution_model{
final String Company;
final int Compnay_ID;
final double Sales;
final double Booked;
final String Executed;
final String Execution;
final double UnqCust;
final bool is_check;

company_execution_model({
  required this.Company,
  required this.Compnay_ID,
  required this.Sales,
  required this.Booked,
  required this.Executed,
  required this.Execution,
  required this.UnqCust,
  required this.is_check
});

factory company_execution_model.fromJson(Map<String, dynamic> json) {
  return company_execution_model(
    Company: json['Product_Company_Name'] ?? '',
    Compnay_ID: json['Product_Company_Code'] ?? 0,
    Sales: json['Sales_Inc_ST'] ?? 0.0,
    Booked: json['Qty_Supplied'] ?? 0.0,
    Executed: json['Executed'] ?? '',
    Execution: json['Execution_%_(Mean)'] ?? '',
    UnqCust: json['Unique_Customers'] ?? 0.0,
    is_check: false,
  );
 }
}