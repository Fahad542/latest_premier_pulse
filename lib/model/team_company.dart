class Team_compnay {
  final String companyName;
  final String companyID;
    bool ischecked;
  // Add the isChecked field

  Team_compnay({
   required this.companyName,
    required this.companyID,
     this.ischecked=false,
    // Include the isChecked parameter
  });
  factory Team_compnay.fromJson(Map<String, dynamic> json) {
    return Team_compnay(
      companyName: json['Product_Company_Name'],
      companyID: json['Product_Company_ID'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Product_Company_Name': companyName,
      'Product_Company_ID': companyID,
    };
  }
   Map<String, dynamic> toMap() {
    return {
      'Product_Company_Name': companyName,
      'Product_Company_ID': companyID,
    };
}
}