import 'package:mvvm/model/division_type_model.dart';

import 'api_services.dart';

class division_type_Repository {

  final PostApiService _apiService = PostApiService();
  Future<List> team_company_fetchData(String startdate, String enddate) async {
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);
    final requestData =
    [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": "Class",
        "MeasureName": [
         "Sales Inc ST",
          "Sales Excl ST"
    ]
      }
    ];
    print(requestData);
    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}
