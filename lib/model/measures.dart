class Measure {
  final String measureName;
  final String measureGroupName;
  final String measureDisplayFolder;

  Measure({
    required this.measureName,
    required this.measureGroupName,
    required this.measureDisplayFolder,
  });

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
      measureName: json['MEASURE_NAME'],
      measureGroupName: json['MEASUREGROUP_NAME'],
      measureDisplayFolder: json['MEASURE_dISPLAY_FOLDER'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MEASURE_NAME': measureName,
      'MEASUREGROUP_NAME': measureGroupName,
      'MEASURE_dISPLAY_FOLDER': measureDisplayFolder,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'measureName': measureName,
      'measureGroupName': measureGroupName,
      'measureDisplayFolder': measureDisplayFolder,
    };
  }
}
