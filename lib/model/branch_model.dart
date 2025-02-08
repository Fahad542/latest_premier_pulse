class Branch_compnay
{
  final String BranchName;
  final int BranchID;
bool ischecked;
  Branch_compnay(
      {
    required this.BranchName,
    required this.BranchID,
    this.ischecked=false,
  });
  factory Branch_compnay.fromJson(Map<String, dynamic> json) {
    return Branch_compnay(
      BranchName: json['Branch_Branch_Report_Name'],
      BranchID: json['Branch_Branch_Code'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Branch_Branch_Report_Name': BranchName,
      'Branch_Branch_Code': BranchID.toString(),
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'Branch_Branch_Report_Name': BranchName,
      'Branch_Branch_Code': BranchID.toString(),
      // Convert bool to 1 or 0
    };
  }
}