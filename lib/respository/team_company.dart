import 'dart:convert';

import 'package:mvvm/model/team_company.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import '../model/company_execution_model.dart';
import 'api_services.dart';

class team_company_Repository {

  final PostApiService _apiService = PostApiService();


  Future<List> masterapi(

      String startdate,
      String enddate,
      String column_name,
      List<String> className ,
      List<String> companycode
      , List<String> categorycode
      , List<String> sub_categorycode
      , List<String> brand_code
      , List<String> productcode,
       List<String> measures,) async {
    // Remove "Sales Inc ST" from measures if it exists
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }

    // Prepare the URL
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);

    // Clean up the data by filtering out "null" values from lists
    final cleanedCompanyCode = companycode.where((item) => item != 'null' && item.isNotEmpty).toList();
    final cleanedCategoryCode = categorycode.where((item) => item != 'null' && item.isNotEmpty).toList();
    final cleanedSubCategoryCode = sub_categorycode.where((item) => item != 'null' && item.isNotEmpty).toList();
    final cleanedBrandCode = brand_code.where((item) => item != 'null' && item.isNotEmpty).toList();
    final cleanedProductCode = productcode.where((item) => item != 'null' && item.isNotEmpty).toList();


    final requestData = [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": column_name,
        "ClassName": className.isEmpty ? [] : className,  // Handle ClassName as an empty list if necessary
        "CompanyCode": cleanedCompanyCode.isNotEmpty ? cleanedCompanyCode : [],
        "CategoryCode": cleanedCategoryCode.isNotEmpty ? cleanedCategoryCode : [],
        "SubCategoryCode": cleanedSubCategoryCode.isNotEmpty ? cleanedSubCategoryCode : [],
        "BrandCode": cleanedBrandCode.isNotEmpty ? cleanedBrandCode : [],
        "ProductCode": cleanedProductCode.isNotEmpty ? cleanedProductCode : [],
        "MeasureName": [...measures, "Sales Inc ST"]
      }
    ];


    print(jsonEncode(requestData));

    try {
      var response = await _apiService.postData1(url, requestData);
      print("API Response: $response");

      return response;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }






































  Future<List> team_company_fetchData(String startdate, String enddate, List<String> measures, List<String> ClassName) async {
    // Remove "Sales Inc ST" from measures if it exists
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }

    // Prepare the URL
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);

    // Prepare the request data
    final requestData = [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": "Company",
        if (ClassName.isNotEmpty)
          "ClassName": ClassName, // Only include if not empty
        "MeasureName": [...measures, "Sales Inc ST"], // Add "Sales Inc ST" at the end
           // Only include if ClassName is not empty
      }
    ];

    // Print request data for debugging
    print(jsonEncode(requestData));

    try {
      // Make the POST request to the API
      var response = await _apiService.postData1(url, requestData);
      print("API Response: $response");

      // Return the response or handle it appropriately (e.g., parse the data)
      return response;
    } catch (e) {
      // Handle errors such as network issues, invalid response, etc.
      print('Error: $e');
      return [];
    }
  }
























}


class team_company_Repository_all {

  final PostApiService _apiService = PostApiService();
  Future<List> team_company_fetchData(String startdate, String enddate,String name,List<String> measures) async {
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
        "ColumnName": name,
      "MeasureName":[...measures,"Sales Inc ST"]

      }
    ];
    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}







