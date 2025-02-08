import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/version_model.dart';

class versionrespository {

  Future<VersionModel> fetchVersion() async {
    final response = await http.get(Uri.parse('https://se.premierspulse.com/booster_service/premier_pulse_versioncontrol.php'));

    if (response.statusCode == 200) {
    print(response.body);
      return VersionModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load version');
    }
  }
}