

import 'dart:convert';

import 'package:mvvm/model/customer_wise_model.dart';
import 'package:http/http.dart' as http;

import 'api_services.dart';
class customerRepository {
  final PostApiService _apiService = PostApiService();

  Future<List> customer_wise_fetchData(String empCodes, String startDate, String endDate,  List<int> companycode, List<int> branchcode,List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }

    final url = 'https://api.psplbi.com/api/cmeasure';
    print(url);
    final requestData =
    [
      {
        "DSFCode": empCodes,
        "FirstDate": startDate,
        "LastDate": endDate,
        "CompanyID": companycode,
        "BranchID": branchcode,
       // "MeasureName":[... measures, "Sales Inc ST"]
        "MeasureName":["Sales Inc ST"]
      }
    ];
    print(jsonEncode(requestData));

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
  }

// Similarly, update other repository classes

// class customerRepository {
//   final BaseApiServices _apiServices = NetworkApiService();
//
//   Future<List<Customer>> customer_wise_fetchData(
//       String empCodes, String startDate, String endDate) async {
//     try {
//       final response = await http.get(Uri.parse('https://bi-api.premiergroup.com.pk/api/v4/"$empCodes"/$startDate/$endDate'));
//    //print("https://bi-api.premiergroup.com.pk/api/v4/$empCodes/$startDate/$endDate");
//       //print('Response: ${response.body}'); // Print the received response
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return List<Customer>.from(
//             data.map((json) => Customer.fromJson(json)));
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
