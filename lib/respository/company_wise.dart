import 'dart:convert';

import 'package:mvvm/model/Company_wise.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm/model/pichart_model.dart';
import 'package:mvvm/utils/utils.dart';

import 'api_services.dart';


// class companyRepository {
//
//   final PostApiService _apiService = PostApiService();
//
//   Future<List<Company>> company_wise_fetchData(String empCodes,
//       String startdate, String enddate, List<int> companycode,List<int> branchcode) async {
//     final url = 'https://api.psplbi.com/api/ccoymeasure';
//     print(url);
//     final requestData =
//     [
//       {
//         "DSFCode": empCodes,
//         "FirstDate": startdate,
//         "LastDate": enddate,
//         "CompanyID": companycode,
//         "BranchID": branchcode
//       }
//     ];
//
//
//     return _apiService.postData(url, requestData, (data) =>
//     List<Company>.from(
//         data.map((json) => Company.fromJson(json))));
//   }
//   Future<List> customer_company_fetchData(
//       String empCodes,
//       String customerid, String startDate, String endDate, List<int> companycode,List<int> branchcode, List<String> measures) async {
//     for (int i = 0; i < measures.length; i++) {
//       if (measures[i] == "Sales Inc ST") {
//         measures.removeAt(i);
//         break; // Exit the loop after removing the value
//       }
//     }
//
//     final url = 'https://api.psplbi.com/api/ccoymeasure';
//     print(url);
//     final requestData =
//     [
//       {
//         "DSFCode": empCodes,
//         "CustCode": customerid,
//         "FirstDate": startDate,
//         "LastDate": endDate,
//         "CompanyID":companycode,
//         "BranchID": branchcode,
//         "MeasureName":[... measures, "Sales Inc ST"]
//       }
//     ];
//     print(jsonEncode(requestData));
//
//     var response = await _apiService.postData1(url, requestData);
//     print("api data: $response");
//     return response;
//   }




  class companyRepository {
  final PostApiService _apiService = PostApiService();


  Future<List> company_wise_fetchData(
  String empCodes,
  String startdate, String enddate, List<int> companycode,List<int> branchcode, List<String> measures) async {
  for (int i = 0; i < measures.length; i++) {
  if (measures[i] == "Sales Inc ST") {
  measures.removeAt(i);
  break; // Exit the loop after removing the value
  }
  }

  final url = 'https://api.psplbi.com/api/ccoymeasure';
  print(url);
  final requestData =
  [
  {
  "DSFCode": empCodes,
  "FirstDate": startdate,
  "LastDate": enddate,
  "CompanyID": companycode,
  "BranchID": branchcode,
    "MeasureName":["Sales Inc ST"]
  }
  ];
  print(jsonEncode(requestData));

  var response = await _apiService.postData1(url, requestData);
  print("api data: $response");
  return response;
  }
  }

























  class PichartRepositiory {


  final ApiService _apiService = ApiService();

  Future<List<Pichart>> pichart_fetchData(
      String empCodes, String yearmonth) async {
    final url = 'https://bi-api.premiergroup.com.pk/api/v10/"$empCodes"/"$yearmonth"';
    print(url);
    return _apiService.fetchData(url, (data) => List<Pichart>.from(data.map((json) => Pichart.fromJson(json))));
  }

}
