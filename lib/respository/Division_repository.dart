import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/division_model.dart';
import 'api_services.dart';




class division_Repository {

  final PostApiService _apiService = PostApiService();
  Future<List> fetchData(String startdate, String enddate,String classname, List<String> companycode
      , List<String> categorycodes, List<String> subcategoryCodes, List<String> brandscodes, List<String> skutypes,  List<String>measures
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
        "ColumnName": "Brand",
        "ClassName": [classname],
        "CompanyCode": companycode,
        "CategoryCode": categorycodes,
        "SubCategoryCode": subcategoryCodes,
        "BrandCode": brandscodes,
        "ProductCode": skutypes,
        "MeasureName":[...measures,"Sales Inc ST"]
      }
    ];
    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }


  Future<List> fetchDataall(String startdate, String enddate, List<String> companycode
      , List<String> categorycodes, List<String> subcategoryCodes, List<String> brandscodes, List<String> skutypes,  List<String>measures
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
        "ColumnName": "Brand",
        "CompanyCode": companycode,
        "CategoryCode": categorycodes,
        "SubCategoryCode": subcategoryCodes,
        "BrandCode": brandscodes,
        "ProductCode": skutypes,
        "MeasureName":[...measures,"Sales Inc ST"]
      }
    ];
    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}
