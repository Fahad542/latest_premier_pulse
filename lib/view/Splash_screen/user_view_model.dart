import 'package:flutter/cupertino.dart';
import 'package:mvvm/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier
{

  Future<bool> saveUser(AuthModel user)
  async {

    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('emp_name', (user.EmpName.toString()));
    sp.setString('emp_code', user.EmpCode.toString());
    sp.setString('emp_designation', user.EmpDesignation.toString());
    sp.setString('depth', user.Depth.toString());
    notifyListeners();
    return true ;
  }

  Future<AuthModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? name = sp.getString('emp_name');
    final String? code = sp.getString('emp_code');
    final String? designation = sp.getString('emp_designation');
    final String? depthString = sp.getString('depth');
    final int depth = int.tryParse(depthString ?? '') ?? 0;
    return AuthModel(EmpCode: code.toString(), EmpDesignation: designation.toString(), EmpName: name.toString(), Depth: depth, ReportTo: '');
                                    }

  Future<bool> remove()
  async {

    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('emp_name');
    sp.remove('emp_code');
    sp.remove('emp_designation');
    sp.remove('depth');
    return true;

  }

}