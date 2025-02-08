import 'package:flutter/material.dart';
import 'package:mvvm/utils/app_colors.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../respository/measure_repository.dart';
import '../../utils/Drawer.dart';
import '../Splash_screen/user_view_model.dart';

Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  final userPrefernece = Provider.of<UserViewModel>(context, listen: false);
  await salesViewModel.initializeDatabase();
  final repository = measure_repository();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: AppColors.primary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Confirm Logout',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16.0,
                    color: AppColors.white
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String empCode = prefs.getString('emp_code') ?? '';
                      String empName = prefs.getString('emp_name') ?? '';
                      String des = prefs.getString('emp_designation') ?? '';
                     await  salesViewModel.deletetable();
                     await repository.clearMeasures();
                      // Check if the necessary data is present
                      if (empCode.isNotEmpty && empName.isNotEmpty) {
                        prefs.clear();
                      }
                      // Perform logout and navigate to the login screen
                      userPrefernece.remove().then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView()));

                        //Navigator.pushNamed(context, RoutesName.login);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
