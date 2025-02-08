import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_services.dart';

class customer_product_Repository {


  final PostApiService _apiService = PostApiService();


  Future<List> customer_product_fetchData(
      String empCodes,String customerid,List<String>companycode,List<int> branchcode,
      String startDate, String endDate, List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break;
      }
    }

    final url = 'https://api.psplbi.com/api/ccypmeasure';
    print(url);
    final requestData =
    [
      {
        "DSFCode": empCodes,
        "CustCode": customerid,
        "FirstDate": startDate,
        "LastDate": endDate,
        "CompanyID": companycode,
        "BranchID": branchcode,
        "MeasureName":["Sales Inc ST"]
      }
    ];
    print(jsonEncode(requestData));
    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}



