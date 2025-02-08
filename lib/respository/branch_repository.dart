import '../model/branch_model.dart';
import 'api_services.dart';


class branch_Repository {

  final GetApiService _apiService = GetApiService();
  Future<List<Branch_compnay>> team_company_fetchData() async {
    final url = 'https://api.psplbi.com/api/brinfo';
    print(url);
    return _apiService.getData(url,[], (data) => List<Branch_compnay>.from(data.map((json) => Branch_compnay.fromJson(json))));
  }
}