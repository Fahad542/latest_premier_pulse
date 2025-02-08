
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product_model.dart';
import 'api_services.dart';
class product_Repository {

  final PostApiService _apiService = PostApiService();

  // Future<List<Compnay_ProductModel>> product_fetchData(
  //     String empCodes,String companyid,String startDate, String endDate,List<int>companycode,List<int>branchcode) async {
  // //   final url = 'https://bi-api.premiergroup.com.pk/api/v8/"$empCodes"/"$companyid"/$startDate/$endDate';
  // //   print(url);
  // //   return _apiService.fetchData(url, (data) => List<Compnay_ProductModel>.from(data.map((json) => Compnay_ProductModel.fromJson(json))));
  // // }
  //
  //
  //
  // final url = 'https://api.psplbi.com/api/ccypmeasure';
  // print(url);
  // final requestData =
  // [
  //   {
  //     "DSFCode": empCodes,
  //     "FirstDate": startDate,
  //     "LastDate": endDate,
  //     "CompanyID": companycode,
  //     "BranchID": branchcode,
  //     "MeasureName": [
  //       "Sales Inc ST",
  //       "Sales Excl ST"
  //     ]
  //   }
  //
  // ];



//   return _apiService.postData(url,requestData, (data) =>
//   List<Compnay_ProductModel>.from(
//   data.map((json) => Compnay_ProductModel.fromJson(json))));
//
// }


  Future<List> product_fetchData(
      String empCodes,String companyid,String startDate, String endDate,List<String>companycode,List<int>branchcode, List<String> measures) async {
  for (int i = 0; i < measures.length; i++) {
  if (measures[i] == "Sales Inc ST") {
  measures.removeAt(i);
  break; // Exit the loop after removing the value
  }
  }

  final url = 'https://api.psplbi.com/api/ccypmeasure';
  print(url);
  final requestData =
  [
  {
  "DSFCode": empCodes,
  "FirstDate": startDate,
  "LastDate": endDate,
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




