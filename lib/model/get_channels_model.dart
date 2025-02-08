class get_channels_model{
  final String Class;

  final String Sales;
  final String Booked;
  final String Executed;
  final String Execution;
  final String UnqCust;

  get_channels_model({
    required this.Class,

    required this.Sales,
    required this.Booked,
    required this.Executed,
    required this.Execution,
    required this.UnqCust
  });

  factory get_channels_model.fromJson(Map<String, dynamic> json) {
    return get_channels_model(
      Class: json['Customer_Cust_Class'] ?? '',
      Sales: json['Sales'] ?? '',
      Booked: json['Booked'] ?? '',
      Executed: json['Executed'] ?? '',
      Execution: json['Execution'] ?? '',
      UnqCust: json['UnqCust'] ?? '',
    );
  }
}