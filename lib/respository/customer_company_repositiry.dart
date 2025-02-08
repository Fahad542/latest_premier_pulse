import 'dart:convert';
import 'package:mvvm/model/Company_wise.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm/model/customer_company.dart';

import 'api_services.dart';


class customer_company_Repository {

  final PostApiService _apiService = PostApiService();


  Future<List> customer_company_fetchData(
      String empCodes,
      String customerid, String startDate, String endDate, List<int> companycode,List<int> branchcode, List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break;
      }
    }

    final url = 'https://api.psplbi.com/api/ccoymeasure';
    print(url);
    final requestData =
    [
      {
        "DSFCode": empCodes,
        "CustCode": customerid,
        "FirstDate": startDate,
        "LastDate": endDate,
        "CompanyID":companycode,
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

