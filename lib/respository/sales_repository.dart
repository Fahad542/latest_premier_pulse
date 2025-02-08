
import 'dart:convert';


import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm/view/Login_screen/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/sales_model.dart';
import 'api_services.dart';
import 'authentication and base_url.dart';


class SalesRepository {
  // Future<List> fetchData(
  //     String empCodes, String startDate, String endDate,List<int> companyCodes,List<int> branchcode) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String username = prefs.getString('username') ?? '';
  //     String password = prefs.getString('password') ?? '';
  //     final authCredentials = AuthCredentials(username, password);
  //     // Check for internet connectivity
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //     if (connectivityResult == ConnectivityResult.none) {
  //       Fluttertoast.showToast(
  //         msg: "No Internet Connection",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //       throw Exception('No Internet Connection');
  //     }
  //
  //     // Convert empCodes set to a list
  //     //final empCodesList = empCodes.toList();
  //     final companycodesList = companyCodes.toList();
  //     final requestData =
  //     [
  //     {
  //       "EmpCode": empCodes,
  //       "EmpDesignation": empcode.designation,
  //       "Depth": empcode.depth,
  //       "FirstDate": startDate,
  //       "LastDate": endDate,
  //       "CompanyID": companycodesList,
  //       "BranchID": branchcode,
  //       "MeasureName":["Sales Inc ST"]
  //     }
  //     ];
  //     final response = await http.post(
  //       Uri.parse('https://api.psplbi.com/api/empmeasure'),
  //       body: json.encode(requestData),
  //       headers: {      'Content-Type': 'application/json',
  //         'Authorization': authCredentials.basicAuth,},
  //     );
  //
  //     print('https://api.psplbi.com/api/empmeasure');
  //     print('Request Data: ${json.encode(requestData)}');
  //     print('Body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       return List<SalesData>.from(data.map((json) => SalesData.fromJson(json)));
  //     } else {
  //       print('Error - Status Code: ${response.statusCode}');
  //       print('Error - Body: ${response.body}');
  //       throw Exception('Failed to load data. Server returned status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to load data. $e');
  //   }
  // }
  final PostApiService _apiService = PostApiService();
  Future<List> fetchData(String empCodes,String startdate, String enddate, List<int> companyCodes,List<int> branchcode,List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }

    final url = 'https://api.psplbi.com/api/empmeasure';
    print(url);
    final requestData =
    [
      {
        "EmpCode": empCodes,
        "EmpDesignation": empcode.designation,
        "Depth": empcode.depth,
        "FirstDate": startdate,
        "LastDate": enddate,
        "CompanyID": companyCodes,
        "BranchID": branchcode,
        "MeasureName":[... measures, "Sales Inc ST"]
      }
    ];
    print(jsonEncode(requestData));

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}



// class SalesRepositry {
//   Future<List<SalesData>> fetchData(
//       dynamic empCodes, String startDate, String endDate) async {
//     try {
//       // Check for internet connectivity
//       var connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         // No internet connection, show a toast or handle accordingly
//         Fluttertoast.showToast(
//           msg: "No Internet Connection",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//         throw Exception('No Internet Connection');
//       }
//
//       // Convert empCodes to Set<String>
//       Set<String> empCodesSet;
//       if (empCodes is String) {
//         empCodesSet = {empCodes};
//       } else if (empCodes is Set<String>) {
//         empCodesSet = empCodes;
//       } else {
//         throw ArgumentError(
//             'empCodes must be either a String or a Set<String>');
//       }
//
//       // Join the empCodes set with commas
//       final empCodesParam = empCodesSet.join(',');
//
//       final response = await http.get(Uri.parse(
//           'https://bi-api.premiergroup.com.pk/api/v11/$empCodesParam/$startDate/$endDate'));
//        print( 'https://bi-api.premiergroup.com.pk/api/v11/$empCodesParam/$startDate/$endDate');
//       //print('Response: ${response.body}'); // Print the received response
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return List<SalesData>.from(
//             data.map((json) => SalesData.fromJson(json)));
//       } else {
//         print('Error - Status Code: ${response.statusCode}');
//         print('Error - Body: ${response.body}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Failed to load data');
//     }
//   }
// }
