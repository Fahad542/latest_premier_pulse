import 'dart:convert';

import '../model/dsf_measure_model.dart';
import 'api_services.dart';

class dsf_measure_Repository {

  final PostApiService _apiService = PostApiService();

  Future<List<DsfMeasureModel>> fetchData(String startdate, String enddate,
      int dsfcode) async {
    final url = 'https://api.psplbi.com/api/dsfmmeasures';
    print(url);
    final requestData =
    [
      {
        "FirstDate":startdate,
        "LastDate": enddate,
        "DSFCode": dsfcode,
        "MeasureName":
        [
          "SAF Customer","Productive Customer","ECO%","First Order","Last Order","Duration",
          "Order Quantity","Order Value",
          "Avg Value Per Bill","Avg SKU Per Bill","DSFTarget Days DSF Remaining",
          "DSFTarget Days DSF Worked",
          "DSFTarget %","DSFTarget Remaining","DSFTarget Per Day Required","DSFTarget Expected Landing",
          "DSFTarget Value","Booking Quantity","Booking Value Inc ST"
        ]
      }
    ];
    print("Datassss: ${json.encode(requestData)}");

    return _apiService.postData(url, requestData, (data) =>

    List<DsfMeasureModel>.from(

      data.map((json) => DsfMeasureModel.fromJson(json),),),);

  }
}