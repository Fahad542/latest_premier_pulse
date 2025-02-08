import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';
import 'authentication and base_url.dart';

class ApiService {
  Future<T> fetchData<T>(String url, T Function(dynamic) fromJson) async {
    try {
      // Check internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        Utils.toastMessage('No internet connection');
        throw Exception('No internet connection');
      }

      final response = await http.get(Uri.parse(url));

      switch (response.statusCode) {
        case 200:
          final List<dynamic> data = json.decode(response.body);
          return fromJson(data);
        case 400:
        // Handle Bad Request
          Utils.toastMessage("Bad Request");
          throw Exception('Bad Request');
        case 401:
        // Handle Unauthorized
          Utils.toastMessage("Unauthorized");
          throw Exception('Unauthorized');
      // Add more cases as needed
        default:
        // Handle other status codes
          Utils.toastMessage('Failed to load data');
          print('Error - Status Code: ${response.statusCode}');
          print('Error - Body: ${response.body}');
          throw Exception('Failed to load data');
      }
    } catch (e) {
      Utils.toastMessage('Failed to load data');
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
}


class PostApiService {
  Future<T> postData<T>(String url, dynamic body, T Function(dynamic) fromJson) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? '';
      String password = prefs.getString('password') ?? '';
      final authCredentials = AuthCredentials(username, password);
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        Utils.toastMessage('No internet connection');
        throw Exception('No internet connection');
      }

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authCredentials.basicAuth,

        },
      );

      switch (response.statusCode) {
        case 200:
          final dynamic data = json.decode(response.body);
          print("datalist : ${data}");
          return fromJson(data);

        case 400:
        // Handle Bad Request
          Utils.toastMessage("Bad Request");
          throw Exception('Bad Request');
        case 401:
        // Handle Unauthorized
          Utils.toastMessage("Unauthorized");
          throw Exception('Unauthorized');
      // Add more cases as needed
        default:
        // Handle other status codes
          Utils.toastMessage('Failed to load data');
          print('Error - Status Code: ${response.statusCode}');
          print('Error - Body: ${response.body}');
          throw Exception('Failed to load data');
      }
    } catch (e) {
      Utils.toastMessage('Failed to load data');
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }



  Future<T> postData1<T>(String url, dynamic body) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? '';
      String password = prefs.getString('password') ?? '';
      final authCredentials = AuthCredentials(username, password);
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        Utils.toastMessage('No internet connection');
        throw Exception('No internet connection');
      }

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authCredentials.basicAuth,

        },
      );

      switch (response.statusCode) {
        case 200:
          final dynamic data = json.decode(response.body);
          print("data: ${response.body}");
          return data;

        case 400:
        // Handle Bad Request
          Utils.toastMessage("Bad Request");
          throw Exception('Bad Request');
        case 401:
        // Handle Unauthorized
          Utils.toastMessage("Unauthorized");
          throw Exception('Unauthorized');
      // Add more cases as needed
        default:
        // Handle other status codes
          Utils.toastMessage('Failed to load data');
          print('Error - Status Code: ${response.statusCode}');
          print('Error - Body: ${response.body}');
          throw Exception('Failed to load data');
      }
    } catch (e) {
      Utils.toastMessage('Failed to load data');
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
}



class GetApiService {
  Future<T> getData<T>(String url, dynamic body, T Function(dynamic) fromJson) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String username = prefs.getString('username') ?? '';

      String password = prefs.getString('password') ?? '';
      final authCredentials = AuthCredentials(username, password);
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
        Utils.toastMessage('No internet connection');
        throw Exception('No internet connection');
      }

      final response = await http.get(
        Uri.parse(url),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': authCredentials.basicAuth,
        },

      );

      switch (response.statusCode) {
        case 200:
          final dynamic data = json.decode(response.body);
          return fromJson(data);
        case 400:
        // Handle Bad Request
          Utils.toastMessage("Bad Request");
          throw Exception('Bad Request');
        case 401:
        // Handle Unauthorized
          Utils.toastMessage("Unauthorized");
          throw Exception('Unauthorized');
      // Add more cases as needed
        default:
        // Handle other status codes
          Utils.toastMessage('Failed to load data');
          print('Error - Status Code: ${response.statusCode}');
          print('Error - Body: ${response.body}');
          throw Exception('Failed to load data');
      }
    } catch (e) {
      Utils.toastMessage('Failed to load data');
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
}
