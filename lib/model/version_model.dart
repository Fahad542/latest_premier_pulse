class VersionModel {
  final String status;
  final String statusMessage;
  final String versionNo;

  VersionModel({
    required this.status,
    required this.statusMessage,
    required this.versionNo,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      status: json['status'],
      statusMessage: json['status_message'],
      versionNo: json['version_no'],
    );
  }
}