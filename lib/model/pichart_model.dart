class Pichart {
  final String? AchPct;
  final String? TargetValue;
  final String? Sales;
  Pichart({
    this.AchPct,
    this.TargetValue,
    this.Sales
  });
  factory Pichart.fromJson(Map<String, dynamic> json) {
    return Pichart(
      AchPct: json['AchPct'],
        TargetValue: json['TargetValue'],
        Sales: json['Sales']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'AchPct': AchPct,
      'TargetValue':TargetValue,
      'Sales':Sales
    };
  }
}
