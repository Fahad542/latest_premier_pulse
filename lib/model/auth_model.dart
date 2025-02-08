// class AuthModel {
//   List<Data> data;
//
//   AuthModel({required this.data});
//
//   factory AuthModel.fromJson(List<dynamic> json) {
//     List<Data> dataList = json.map((item) => Data.fromJson(item)).toList();
//     return AuthModel(data: dataList);
//   }
// }
//
// class Data {
//   String empCode;
//   String empDesignation;
//   String empName;
//   int depth;
//   String reportTo;
//
//   Data({
//     required this.empCode,
//     required this.empDesignation,
//     required this.empName,
//     required this.depth,
//     required this.reportTo,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       empCode: json['EmpCode'] ?? '',
//       empDesignation: json['EmpDesignation'] ?? '',
//       empName: json['EmpName'] ?? '',
//       depth: json['Depth'] ?? 0,
//       reportTo: json['ReportTo'] ?? '',
//     );
//   }
// }

class AuthModel {
  final String EmpCode;
  final String EmpDesignation; // Add the isChecked field
  final String EmpName;
  final int Depth;
  final String ReportTo;
  AuthModel({
    required this.EmpCode,
    required this.EmpDesignation,
    required this.EmpName,
    required this.Depth,
    required this.ReportTo,
  });
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      EmpCode: json['EmpCode'],
      EmpDesignation: json['EmpDesignation'],
      EmpName: json['EmpName'],
      Depth: json['Depth'],
      ReportTo: json['ReportTo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'EmpCode': EmpCode,
      'EmpDesignation': EmpDesignation,
      'EmpName': EmpName,
      'Depth': Depth,
      'ReportTo': ReportTo,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'EmpCode': EmpCode,
      'EmpDesignation': EmpDesignation,
      'EmpName': EmpName,
      'Depth': Depth,
      'ReportTo': ReportTo,
      // Convert bool to 1 or 0
    };
  }}