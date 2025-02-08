import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Attendance/Mark_Attandance/Mark%20Attendance_view.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/auth_model.dart';
import '../../respository/auth_repository.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool login=false;
  bool done=true;
  bool indicator=false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    _obsecurePassword.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final height  = MediaQuery.of(context).size.height * 1 ;
    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: Scaffold(
         backgroundColor:  AppColors.greencolor,
          //resizeToAvoidBottomInset: false,
          body:  Column(


            children: [
              Spacer(),
              Image.asset('assets/pulsenewicon.png', height: 300, width: 300, color: Colors.white,),
              Expanded(
                flex: 10,
                child: Container(

                    padding: EdgeInsets.only(left: 10, right: 10),
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40.0),
                           // bottom: Radius.circular(15.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greencolor.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,

                        ),
                         // height: 500,
                        //width: double.infinity,
                        child:   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  SingleChildScrollView(
                    child: Column(

                      children: [

                         SizedBox(height: 20,),
                        Builder(
                          builder: (context) {
                            return Theme(
                              data: ThemeData(
                                inputDecorationTheme: InputDecorationTheme(
                                  hintStyle: TextStyle(color: AppColors.greencolor), // Set hint text color to green
                                  labelStyle: TextStyle(color: AppColors.greencolor), // Set label text color to green
                                ),
                                textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: Colors.black, // Set the text cursor color to black
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                 // height: 50,
                                  decoration: BoxDecoration(
                                   color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                  BoxShadow(
                                  color: AppColors.greencolor.withOpacity(0.4), // Green shadow
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                  )],

                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: emailFocusNode,
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                      color: AppColors.greencolor, // Set the entered text color to black
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Username',
                                      labelText: 'Username',
                                      prefixIcon: Icon(Icons.alternate_email, color: AppColors.greencolor),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onFieldSubmitted: (value) {
                                      Utils.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height * .04,),
                        ValueListenableBuilder(
                            valueListenable: _obsecurePassword,
                            builder: (context , value, child){

                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                    //height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.greencolor.withOpacity(0.3), // Green shadow
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        )],
                                borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Theme(
                                data: ThemeData(
                                inputDecorationTheme: InputDecorationTheme(
                                hintStyle: TextStyle(color: AppColors.greencolor), // Set hint text color to green
                                labelStyle: TextStyle(color: AppColors.greencolor), // Set label text color to green
                                ),
                                ),
                                child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obsecurePassword.value,
                                focusNode: passwordFocusNode,
                                obscuringCharacter: "*",
                                  style: TextStyle(
                                    color: AppColors.greencolor,
                                    fontSize: 15,// Set the entered text color to black
                                  ),
                                decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',

                                prefixIcon: Icon(Icons.lock_open_rounded, color: AppColors.greencolor),
                                suffixIcon: InkWell(
                                onTap: () {
                                _obsecurePassword.value = !_obsecurePassword.value;
                                },
                                child: Icon(
                                _obsecurePassword.value ? Icons.visibility_off_outlined : Icons.visibility,color: AppColors.greencolor
                                ),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                ),
                                ),
                                )),
                              );


                            }
                        ),
                        SizedBox(height: height * .07,),

                        Visibility(
                          visible: done,
                          child: RoundButton(
                            title: 'LOGIN',
                            onPress: () async {
                              var connectivityResult = await Connectivity().checkConnectivity();
                              if (connectivityResult == ConnectivityResult.none) {
                                // No internet connection, show a toast or any other indication
                                Utils.flushBarErrorMessage("No Internet Connection", context);
                                return;
                              }

                              if (_emailController.text.isEmpty) {
                                Utils.flushBarErrorMessage('Please enter email', context);
                              } else if (_passwordController.text.isEmpty) {
                                Utils.flushBarErrorMessage('Please enter password', context);
                              } else {
                                setState(() {
                                  done = false;
                                  indicator = true;
                                });
                                AuthRepository().login(_emailController.text.toString(), _passwordController.text.toString())
                                    .then((List<AuthModel> authModels) async {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('username', _emailController.text.toString());
                                  await prefs.setString('password', _passwordController.text.toString());

                                  if (authModels.isNotEmpty) {
                                    await AuthRepository().saveData(
                                      authModels[0].EmpCode,
                                      authModels[0].EmpName,
                                      authModels[0].EmpDesignation,
                                      authModels[0].Depth.toString(),
                                    );
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String username =  prefs.getString('username') ?? '';
                                    String password =  prefs.getString('password') ?? '';
                                    String empCode =  prefs.getString('emp_code') ?? '';
                                    String empName =  prefs.getString('emp_name') ?? '';
                                    String depth =  prefs.getString('depth') ?? '';
                                    String empDesignation = prefs.getString('emp_designation') ?? '';
                                    if (empCode.isNotEmpty && empName.isNotEmpty) {
                                      await salesViewModel.initializeDatabase();
                                      final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
                                      if (!isTableEmpty) {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Markattendance()));
                                      } else {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Markattendance()));

                                        Utils.flushBarErrorMessage("Please Mark your Attendance", context);
                                      }
                                      Utils.snackBar("Login Successful", context);
                                      setState(() {
                                        empcode.updateValues(
                                            empCode,
                                            empName,
                                            empDesignation,
                                            username,
                                            password,
                                            depth
                                        );
                                      });
                                    }
                                  } else {
                                    Utils.flushBarErrorMessage('Invalid Credentials', context);
                                    setState(() {
                                      done = true;
                                      indicator = false;
                                    });
                                    print('API response is not as expected');
                                  }
                                })
                                    .catchError((error) {
                                      setState(() {
                                        done = true;
                                        indicator = false;
                                        Utils.flushBarErrorMessage('Invalid Credentials', context);
                                      });

                                  print('API call error: $error');
                                });
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: indicator,
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )

                        ,
                        SizedBox(height: 150,),
                        Text("Version: 2.0.0", style: TextStyle(color: AppColors.primary, fontSize: 14),)
                    ]
                    ),
                  )
                )),
              ),

            ],
          )

          ),
    );

  }
}

class empcode
{
  static String auth='';
  static String name='';
  static String designation='';
  static String username='';
  static String password='';
  static String depth='';
  static void updateValues(
      String newAuth,
      String newName,
      String newdesignation,
      String newusername,
      String newpassword,
      String newdepth
      )
  {
    auth = newAuth;
    name = newName;
    designation= newdesignation;
    username =newusername;
    password =newpassword;
    depth=newdepth;
  }

}