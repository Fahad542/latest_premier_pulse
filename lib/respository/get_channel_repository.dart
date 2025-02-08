import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm/model/get_channels_model.dart';

import 'api_services.dart';

// class get_channel_Repository {
//   Future<List<get_channels_model>> fetchData(
//       List<String> empCodes,String column, String startDate, String endDate,List<String> companyCodes,List<String> branchCodes,List<String> divisionscodes,List<String> categorycodes,List<String> subcategoryCodes,List<String> brandscodes,List<String> skutypes,List<String> custclass) async {
//     try {
//       // Check for internet connectivity
//       var connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
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
//       // Convert empCodes set to a list
//       final empCodesList = empCodes.toList();
//       final companycodesList = companyCodes.toList();
//       final requestData = {
//         "column": column ,
//         'start_date': startDate,
//         'end_date': endDate,
//         'employee_codes': empCodesList,
//         "company_codes": companycodesList,
//         "branch_codes": branchCodes,
//         "division_codes": divisionscodes,
//         "category_codes": categorycodes,
//         "subcategory_codes": subcategoryCodes,
//         "brand_codes":brandscodes,
//         "sku_type": skutypes,
//         "cust_class": custclass
//       };
//
//       final response = await http.post(
//         Uri.parse('https://bi-api.premiergroup.com.pk/api/m/v2'),
//         body: json.encode(requestData),
//         headers: {'Content-Type': 'application/json',
//           'Authorization': 'Basic dXNlcjE6cGFzczE='},
//       );
//
//       print('https://bi-api.premiergroup.com.pk/api/m/v2');
//       print('Request Data: ${json.encode(requestData)}');
//       print('Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return List<get_channels_model>.from(data.map((json) => get_channels_model.fromJson(json)));
//       } else {
//         print('Error - Status Code: ${response.statusCode}');
//         print('Error - Body: ${response.body}');
//         throw Exception('Failed to load data. Server returned status ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Failed to load data. $e');
//     }
//   }
// }



class get_channel_Repository {

  final PostApiService _apiService = PostApiService();
  Future<List<get_channels_model>> fetchData( String startdate, String enddate, List<int>companyid) async {
    final url = 'https://api.psplbi.com/api/ccmeasure';
    print(url);
    final requestData =
    [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "CompanyID": companyid
      }
    ];
    return _apiService.postData(url,requestData, (data) =>
    List<get_channels_model>.from(
        data.map((json) => get_channels_model.fromJson(json))));
  }
}
