import 'dart:async';
import 'dart:ffi';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res/color.dart';
import '../../../respository/measure_repository.dart';
import '../../../utils/Drawer.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/homeappbar.dart';
import '../../../utils/utils.dart';
import '../../Home/home_screen.dart';
import '../../Executive_sale/Team_analysis/Sales_viewmodel.dart';
import '../../Splash_screen/splash_view.dart';

class Markattendance extends StatefulWidget {
  Markattendance ({Key? key}) : super(key: key);

  @override
  State< Markattendance > createState( ) => _MarkattendanceState( );
}

class _MarkattendanceState extends State< Markattendance > {
  String currentTime='';
  String lastSyncDate='';
  double latitude=0.0;
  double longitude=0.0;
  String currentTimes='';
  String username='';
  String usercode='';
  String role='';
  bool isLocationPermissionGranted = false;
  final repository = measure_repository();


  void get() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    username = sp.getString('emp_name').toString();
    usercode = sp.getString('emp_code').toString();
     role = sp.getString('emp_designation').toString();
    lastSyncDate= sp.getString('lastSyncDate') ??'';
    currentTime= sp.getString('currentTime')?? '';
    latitude= sp.getDouble('latitude') ?? 0.0;
    longitude=sp.getDouble('longitude') ?? 0.0;
    setState(() {});
  }


  void delete() async {
    await salesViewModel.initializeDatabase();
    if(lastSyncDate != DateFormat.yMd().format(DateTime.now()) )
    {
      await salesViewModel.deletetable();
      await repository.clearMeasures();
    }
  }


  void geo(Double lat , Double long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }


  @override
  void initState() {
    get();
    delete();
    version v =version();

    super.initState();

  }



  GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  HomeScreen home=HomeScreen();


  String currentTimeString='';

  final salesViewModel = SalesHeirarchyViewModel();
  String emp = "";
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {

            return await Exit.showExitDialog(context);

        },
        child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey1,
          appBar: GeneralAppBar(
            title: "DATA SYNC",
            ontapmenu: ()
            {
              scaffoldKey1.currentState?.openDrawer();
            },

          ),

          drawer: CustomDrawer(),
          body:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Column(

                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greencolor!.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          Image.asset(
                            "assets/dp_default.png", height: 120, width: 100,),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200, // Define a width for the container
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Name: ", // Heading
                                        style: TextStyle(
                                          color: Colors.black,

                                          fontSize: 14,
                                         // fontFamily: "MeriendaBold",
                                        ),
                                      ),
                                      TextSpan(
                                        text: username.toString(),
                                        // Displaying the username
                                        style: TextStyle(
                                          color: AppColors.greencolor,
fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          //fontFamily: "MeriendaBold",
                                        ),

                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 7,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Code: ", // Heading
                                      style: TextStyle(
                                        color: Colors.black,
                                        // You can adjust the color for the heading

                                        fontSize: 15,
                                        //fontFamily: "MeriendaBold",
                                      ),
                                    ),
                                    TextSpan(
                                      text: usercode.toString(),
                                      // Displaying the username
                                      style: TextStyle(
                                        color: AppColors.greencolor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        //fontFamily: "MeriendaBold",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 7,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Designation: ", // Heading
                                      style: TextStyle(
                                        color: Colors.black,
                                        // You can adjust the color for the heading

                                        fontSize: 14,
                                       // fontFamily: "MeriendaBold",
                                      ),
                                    ),
                                    TextSpan(
                                      text: role.toString(),

                                      // Displaying the username
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.greencolor,

                                        fontSize: 15,
                                       // fontFamily: "MeriendaBold",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
          SizedBox(height: 30,),
          Text("Current time",
            textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,

                      fontSize: 18,
                      fontFamily: "MeriendaBold",
                    ),),

                  CurrentTimeWidget(currentTimes: currentTimes,),
                  SizedBox(height: 30,),
                  Text("Current date and day", textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,

                      fontSize: 18,
                      fontFamily: "MeriendaBold",
                    ),),
                  SizedBox(height: 10,),
                  DateDisplayWidget(),
                  SizedBox(height: 30,),

                  Text("Last time mark attendance date",
                    textAlign: TextAlign.start, style: TextStyle(
                      color: Colors.black,

                      fontSize: 18,
                      //fontFamily: "MeriendaBold",
                    ),),
                  SizedBox(height: 10,),

                  lasttimedate(date: lastSyncDate,),

                  //Spacer(),
                  SizedBox(height: 10,),


              ],
            ),
          ),
        ]),
            bottomNavigationBar:

            AttendanceButton(
              onPressed: () async {

                var connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {

                  Fluttertoast.showToast(
                    msg: "No Internet Connection",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                var permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.always || permission == LocationPermission.whileInUse && latitude=='' && longitude=='') {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Location Permission Required'),
                        content: Text('Please enable location access in your device settings to use this feature.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();

                            },
                          ),
                        ],
                      );
                    },
                  );
                }


                await salesViewModel.initializeDatabase();
                bool isTableEmpty = await salesViewModel.isDatabaseTableEmpty();

                if (!isTableEmpty) {

                  Fluttertoast.showToast(
                    msg: "Attendance is already marked",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: AppColors.ligthgreen,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.best,
                );

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.transparent,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greencolor),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Please wait...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );

                try {
                  final measure = await measure_repository();
                  await salesViewModel.initializeDatabase();
                  await salesViewModel.fetchHeirarchyListApi();
                  await salesViewModel.fetchTeamCompanyApi();
                  await salesViewModel.fetchbranchapi();
                  await measure.database();
                  await measure.fetchDataAndSave();
                  await salesViewModel.initializeDatabase();
                  final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
                  if(!isTableEmpty){
                    setState(() {
                      lastSyncDate = DateFormat.yMd().format(DateTime.now());
                      currentTime = DateFormat.jm().format(DateTime.now());
                      latitude = position.latitude;
                      longitude = position.longitude;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('lastSyncDate', lastSyncDate!);
                    await prefs.setString('currentTime', currentTime!);
                    SharedPreferences pref = await SharedPreferences.getInstance();    // await pref.setDouble('latitude', latitude);
                    await pref.setDouble('longitude', longitude);
                    await pref.setDouble('latitude', latitude);
                    currentdate.date=lastSyncDate;
                    print(currentdate.date);
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppColors.greencolor,
                          title: Text(
                            "Attendance Marked",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            "Your attendance has been marked.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                FocusScope.of(context).unfocus();
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );}
                  else{
                    Utils.flushBarErrorMessage("Error to load data", context);
                  }
                } catch (error) {

                  Navigator.of(context).pop();


                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.red,
                          title: Text(
                            "Error",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            "An error occurred while marking attendance.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),


                            )]);
                    },
                  );
                }


              },),

        ),

    );
  }
}


class currentdate {

  static String? date;

  static void updated_date(String update)
  {
    date = update;
  }

}

class AttendanceButton extends StatelessWidget {
  final VoidCallback onPressed;

  AttendanceButton( {required this.onPressed} );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.greencolor!, AppColors.greencolor!!], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Center(
            child: Text(
              "SYNC DATA",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "MeriendaBold",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class lasttimedate extends StatelessWidget
{
  String? date;
  lasttimedate({required this.date});
  @override
  Widget build(BuildContext context) {
    return
      Padding
        (
      padding: const EdgeInsets.all(8.0),
      child:
      Container
        (
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.greencolor!.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [

                Text(
                  date.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold, fontFamily: "MeriendaBold",
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}





class DateDisplayWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    String dayOfWeek = DateFormat('EEEE').format(now);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.greencolor!.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Current Date",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold, fontFamily: "MeriendaBold",
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: AppColors.greencolor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold, fontFamily: "MeriendaBold",
                  ),
                ),
              ],
            ),

            Container(
              width: 1,
              height: 30, // Adjust height to fit your needs
              color: AppColors.greencolor,
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Text(
                  "Current Day",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold, fontFamily: "MeriendaBold",
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  dayOfWeek,
                  style: TextStyle(
                    color: AppColors.greencolor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "MeriendaBold",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentTimeWidget extends StatefulWidget
{
   String? currentTimes;
   CurrentTimeWidget({required this.currentTimes});
  @override
  _CurrentTimeWidgetState createState() => _CurrentTimeWidgetState();
}

class _CurrentTimeWidgetState extends State<CurrentTimeWidget>
{

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _updateTime();
  }


  void _updateTime() {
    _timer =Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
       widget.currentTimes = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greencolor!.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.currentTimes.toString(),
              style: TextStyle(
                color: AppColors.greencolor!,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "MeriendaBold",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

