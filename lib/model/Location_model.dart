

class LocationData {
  final String latitude;
  final String locationTime;
  final String longitude;

  LocationData({
    required this.latitude,
    required this.locationTime,
    required this.longitude,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toString() ?? '0.0',
      locationTime: json['locationtime']?.toString() ?? 'N/A',
      longitude: json['longitude']?.toString() ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'locationtime': locationTime,
      'longitude': longitude,
    };
  }
}

class LocationResponse {
  final List<LocationData> data;
  final String message;
  final int status;

  LocationResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    List<LocationData> dataList = (list != null && list is List)
        ? list.map((i) => LocationData.fromJson(i)).toList()
        : [];

    return LocationResponse(
      data: dataList,
      message: json['message']?.toString() ?? 'No message',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
      'status': status,
    };
  }
}
