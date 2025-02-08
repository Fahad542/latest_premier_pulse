import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvvm/model/sub_category_model.dart';
import 'package:http/http.dart' as http;

import 'api_services.dart';

class sub_category_Repository {

  final PostApiService _apiService = PostApiService();
  Future<List> fetchData(String startdate,String enddate, String classname, List<String> companycode,
      List<String> CategoryCode,
      List<String> SubCategoryCode,
      List<String> BrandCode,
      List<String> ProductCode,
      List<String>measures
      ) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);
    final requestData =
    [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": "SubCategory",
        "ClassName": [classname],
        "CompanyCode": companycode,
        "CategoryCode": CategoryCode,
        "SubCategoryCode": SubCategoryCode,
        "BrandCode": BrandCode,
        "ProductCode": ProductCode,
        "MeasureName":[...measures,"Sales Inc ST"]
      }
    ];

    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }


  Future<List> fetchDataall(String startdate,String enddate,  List<String> companycode,
      List<String> CategoryCode,
      List<String> SubCategoryCode,
      List<String> BrandCode,
      List<String> ProductCode,
  List<String>measures
      ) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);
    final requestData =
    [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": "SubCategory",
        "CompanyCode": companycode,
        "CategoryCode": CategoryCode,
        "SubCategoryCode": SubCategoryCode,
        "BrandCode": BrandCode,
        "ProductCode": ProductCode,
        "MeasureName":[...measures,"Sales Inc ST"]
      }
    ];

    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}
