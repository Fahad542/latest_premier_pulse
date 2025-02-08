

import 'package:mvvm/respository/auth_repository.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';


class AppUrl {


  static var baseUrl = 'https://reqres.in' ;

  static var moviesBaseUrl = 'https://dea91516-1da3-444b-ad94-c6d0c4dfab81.mock.pstmn.io/' ;

  static var loginEndPint =  baseUrl + '/api/login' ;

  static var registerApiEndPoint =  baseUrl + '/api/register' ;

  static var moviesListEndPoint =  moviesBaseUrl + 'movies_list' ;

  static var heirarchy_url= "https://api.psplbi.com/api/emptree";
  static var Sales_url = "https://bi-api.premiergroup.com.pk/api/v3/";
  static var customer_url = "https://bi-api.premiergroup.com.pk/api/v4/";
}