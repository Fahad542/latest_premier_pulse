import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../model/heirarchy_model.dart';
import '../res/app_url.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:connectivity/connectivity.dart';


import 'authentication and base_url.dart';

class HeirarchyRepository {
  final BaseApiServices _apiServices = NetworkApiService();


  Future<List<UserDetails>> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    final authCredentials = AuthCredentials(username, password);
    try {
      // Check for internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // Internet is available
        final requestData =
[{
    "EmpCode": empcode.auth
    }];
        print("data${json.encode(requestData)}");
        final response = await http.post(
          Uri.parse("https://api.psplbi.com/api/emptree"),
          body: json.encode(requestData),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authCredentials.basicAuth,
          },
        );
print("status:${response.statusCode}");
print("data${json.encode(requestData)}");
        if (response.statusCode == 200) {
          print("object");
          List<dynamic> userDetailsJsonList = json.decode(response.body);

          // Convert the JSON data to a list of UserDetails objects
          List<UserDetails> userDetailsList = userDetailsJsonList.map<
              UserDetails>((data) {
            return UserDetails(
              designation: data['EmpDesignation'].toString(),
              empCode: data['EmpCode'].toString(),
              empName: data['EmpName'].toString(),
              reportingTo: data['ReportTo'].toString(),
              isCheck: data['is_check'] == 'False' ? false : true,
            );
          }).toList();

          return userDetailsList;
        } else {
          // Handle HTTP error

          throw Exception('Failed to load user details${response.statusCode}}');

        }
      } else {
        // No internet connectivity
        Fluttertoast.showToast(
          msg: "No Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return [];
      }
    } catch (e) {
      // Show toast for other exceptions
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      throw e;
    }
  }}
