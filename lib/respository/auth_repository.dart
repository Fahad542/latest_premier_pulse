
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_model.dart';
import 'authentication and base_url.dart';

class AuthRepository {
  Future<void> saveData(String empCode, String empName, String des, String depth) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('emp_code', empCode);
    await prefs.setString('emp_name', empName);
    await prefs.setString('emp_designation',des);
    await prefs.setString('depth', depth);
    print("empcode: $empCode");
    print("empname: $empName");
    print("des: $des");
    print("depth: $depth");
  }


  Future<List<AuthModel>> login(String empCodes, String password) async {
    final url = 'https://api.psplbi.com/api/empinfo';
    print('URL: $url');

    try {
      final authCredentials = AuthCredentials(empCodes, password);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authCredentials.basicAuth,
          // Add other headers as needed
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse');

        if (jsonResponse is List) {
          return jsonResponse.map((data) => AuthModel.fromJson(data)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to make the API call: $error');
    }
  }
}


// class AuthRepository {
//   Future<void> saveData(String empCode, String empName, String des) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('emp_code', empCode);
//     prefs.setString('emp_name', empName);
//     prefs.setString('emp_designation', des);
//     print("empcode: $empCode");
//     print(" empname: $empName");
//     print(" des: $des");
//   }
//   Future<List<AuthModel>> login(String empCodes, String password) async {
//     final url = 'https://hris.premierspulse.com/services/loginScript.php?username=$empCodes&password=$password';
//     print('URL: $url');
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final dynamic jsonResponse = json.decode(response.body);
//         print('Response: $jsonResponse');
//
//         if (jsonResponse is List) {
//
//           return jsonResponse.map((data) => AuthModel.fromJson(data)).toList();
//         } else if (jsonResponse is Map<String, dynamic>) {
//
//           final authModels = [AuthModel.fromJson(jsonResponse)];
//           return authModels;
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         throw Exception('Failed to load data. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//       throw Exception('Failed to make the API call: $error');
//     }
//   }

  ///////////////////////////////////////////////////////////
  // Future<List<Invoice>?> login() async {
  //   final basicAuth = AuthCredentials.basicAuth;
  //   final response = await http.get(
  //     Uri.parse('https://api.psplbi.com/api/auth'),
  //     headers: {'authorization': basicAuth},
  //   );
  //
  //   print(response.body); // Print response body for debugging
  //
  //   if (response.statusCode == 200) {
  //     try {
  //       List<dynamic> jsonList = jsonDecode(response.body);
  //       List<Invoice> invoices = jsonList.map((json) => Invoice.fromJson(json))
  //           .toList(
  //       );
  //       return invoices;
  //     } catch (e) {
  //       print('Error parsing JSON: $e');
  //       return null;
  //     }
  //   } else {
  //     print('Failed to fetch invoice. Status code: ${response.statusCode}');
  //     return null;
  //   }
  // }

