
import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../model/Location_model.dart';


class LoactionRepo {
  NetworkApiService apiServices = NetworkApiService() ;

  Future<LocationResponse> fectdata(String dsfcode, String date) async {

    final url = 'https://booster.b2bpremier.com/services/fetch_dsf_route_journey.php?dsfcode=${dsfcode}&bookingdate=${date}';
    print(url);
    dynamic response = await apiServices.getGetApiResponsewithheareds(url);
    print(response);
    return response= LocationResponse.fromJson(response);
  }

}