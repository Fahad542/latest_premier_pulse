import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm/view/Login_screen/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/company_execution_model.dart';
import 'authentication and base_url.dart';

class company_execution_Repository {
  Future<List<company_execution_model>> fetchData(

      ) async {
    try {
      // Check for internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "No Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('No Internet Connection');
      }

      // Convert empCodes set to a list
      // final empCodesList = empCodes.toList();
      // final companycodesList = companyCodes.toList();
      // final requestData = {
      //   "EmpCode": empCodesList,
      //     "EmpDesignation": empcode.designation,
      //     "Depth": 0,
      //     "FirstDate": startDate,
      //     "LastDate":  endDate,
      //     "CompanyID": companycodesList,
      //     "BranchID": branchCodes
      //
      //
      //
      // };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? '';
      String password = prefs.getString('password') ?? '';
      final authCredentials = AuthCredentials(username, password);
      final response = await http.get(
        Uri.parse('https://api.psplbi.com/api/coyinfo'),
       // body: json.encode(requestData),
        headers: {'Content-Type': 'application/json',
      'Authorization': authCredentials.basicAuth
        },
      );

      print('https://api.psplbi.com/api/coyinfo');
      // print('Request Data: ${json.encode(requestData)}');
      // print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<company_execution_model>.from(data.map((json) => company_execution_model.fromJson(json)));
      } else {
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Body: ${response.body}');
        throw Exception('Failed to load data. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data. $e');
    }
  }
}