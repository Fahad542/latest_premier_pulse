import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mvvm/model/pichart_model.dart';
import 'package:mvvm/model/sales_model.dart';
import 'package:mvvm/respository/company_wise.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import '../../model/heirarchy_model.dart';
import '../../utils/Drawer.dart';
import '../../utils/customs_widgets/circle_avatar_index.dart';
import '../../utils/homeappbar.dart';
import '../../utils/utils.dart';
import '../Executive_sale/Team_analysis/Sales_viewmodel.dart';
import 'conformation_popup.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _SalesReportState();
}
final salesViewModel = SalesHeirarchyViewModel();
bool drawer=false;
DateTime firstDayOfCurrentMonth = Jiffy().startOf(Units.MONTH).dateTime;
DateTime now = DateTime.now();
DateTime lastDayOfCurrentMonth = DateTime(now.year, now.month, now.day);
String formattedFirstDay = DateFormat('yyyy-MM-dd').format(firstDayOfCurrentMonth);
String formattedLastDay = DateFormat('yyyy-MM-dd').format(lastDayOfCurrentMonth);
String formattedToday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));

class _SalesReportState extends State<HomeScreen> {

  String formattedToday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
  bool showInitialHierarchy = true;
  List<SalesData> sales=[];
  String reporting = 'T-${empcode.auth}';
  String reportings = 'T-${empcode.auth}';
  String reportingheirarchy = "T-${empcode.auth}";
  String monthlySale='0';
  late String monthlySaleValue;
  String todaySale='0';
  String? pi='';
  String target='';
  String salev10='';
  late String todaySaleValue;
  LoginView login =LoginView();
 bool isloading=true;
 Set<String> empCodeSet={};
  late String selectedYear;
  late List<String> years;
  late String selectedMonth;
  // ...

  String Year = DateFormat('yyyy').format(DateTime.now()); // Current year
  String Month = DateFormat('MM').format(DateTime.now());
  @override

  void initState() {
    super.initState();
    _updateTime();
    fetchDataAndUpdateState(Year+Month);
    years = List.generate(10, (index) {
      int currentYear = DateTime.now().year;
      return '${currentYear - index}';
    }
    );









    selectedYear = years.first;

    selectedMonth = DateFormat.M().format(DateTime.now());
    setState(() {
      isloading = true;
    });

    if (reporting.isNotEmpty) {

      List<String> empCodeList = reporting.split(',');
      empCodeSet = empCodeList.toSet();

    }
    _loadUserDetails(reportingheirarchy);
  }

  //String empCodeList='';
  String currentTime = '';
  String empCodeString = '';
  void _updateTime() {
    setState(() {
      currentTime = DateFormat.jm().format(DateTime.now());
    });
    // Update the time every second
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  Future<void> fetchDataAndUpdateState(String yearmonth) async {
    try {
      setState(() {
        isloading = true;
      });
      // Assuming PichartRepositiory().pichart_fetchData returns a Future<List<Pichart>?>
      List<Pichart>? salesDataList = await PichartRepositiory().pichart_fetchData(reportings,yearmonth);

      if (salesDataList != null && salesDataList.isNotEmpty) {
        setState(() {
          pi = salesDataList[0].AchPct;
          target = salesDataList[0].TargetValue.toString();
          salev10 = salesDataList[0].Sales.toString();
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (error) {
      // Handle errors
      Utils.flushBarErrorMessage(error.toString(), context);
      setState(() {
        isloading = false;
      });
    }
  }
  Future<void> _loadUserDetails(String reporting) async
  {
    empCodeString='';
    userDetailsList.clear();
    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.select(reporting,'1');
    setState(() {
      userDetailsList = data;
      for (final item in userDetailsList) {

        final String id = item.empCode;

        checkboxStates[id] = item.isCheck;

        setState(() {
          // Add a comma if empCodeString is not empty
          if (empCodeString.isNotEmpty) {
            empCodeString += ',';
          }
          empCodeString += '"$id"';
        });
      }
    });
  }

  String total='0';
  List<UserDetails> userDetailsList = [];
  List<SalesData> SalesList = [];
  List<UserDetails> stackItems = [];
  bool showLoading = false;
  bool customer =false;
  List<SalesData> salesstackItems = [];
  List<SalesData> apiResponseList = [];
  Map<String, bool> checkboxStates = {};
  Set<String> selectedIds={};
  Set<String> selected = {};
  DateTime? startDate;
  DateTime? endDate;
  bool isFirstClick = true;
  bool showChildren = true;

  void setChildrenCheckboxStatesToFalse(String parentId)
  {
    for (final childItem
    in userDetailsList.where((item) => item.reportingTo == 1))

    {
      final String id = childItem.empCode;
      checkboxStates[id] = false;
      final int index = userDetailsList.indexOf(childItem);
      setChildrenCheckboxStatesToFalse(id);
    }
  }

  Widget buildHierarchyTree() {

    final selectedItems = <Widget>[];
    final heirarchy = userDetailsList

        .map<Widget>((childItem) {
      setState(() {

      });
      final String id = childItem.empCode;

      bool isChecked = checkboxStates[id] ?? false;
      if (isChecked) {
        selectedItems.add(
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.green,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(childItem.empName),
                ),
              ],
            ),
          ),
        );
      }



      return ListTile(
        title: InkWell(
          onTap: () {
            setState(() {
              stackItems.add(UserDetails(
                empName: childItem.empName,
                empCode: childItem.empCode,
                reportingTo: childItem.reportingTo,
                designation: childItem.designation,
                isCheck: false,
              ));
              _loadUserDetails(id);
              setChildrenCheckboxStatesToFalse(id);



            });

          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green[800]!,  // Darker shade of green
                  Colors.green[400]!,  // Lighter shade of green
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green[800]??Colors.white,
                  blurRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(

                              children: [
                                Circle_avater(index: userDetailsList.indexOf(childItem)+1),
                                SizedBox(width: 5,),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      //color: Colors.red


                                  ),
                                  child: Text("${childItem.empName}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 13 ),),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                               SizedBox(width: 25,),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black


                                  ),
                                  child: Text("${childItem.designation}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 11 ),),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
               InkWell(
                 onTap: (){

                   // Navigator.push(
                   //   context,
                   //   MaterialPageRoute(
                   //     builder: (context) => SalesReport(data:childItem.empCode)
                   //   ),
                   // );
                 },
                 child: Padding(padding: EdgeInsets.all(4),
                   child: Container(

                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white,),
                       child: Icon(Icons.arrow_circle_right, color: Colors.black,)),

                 ),
               )
              ],
            ),
          ),
        ),
      );
    }).toList();
    if (heirarchy.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Text(
            "No Sub Level Employee Available",
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
        ),
      );
    }
    return
      Column(
        children: heirarchy,

      );
  }
  void showLoadingIndicator() {
    setState(() {
      showLoading = true;
    });
  }

  void hideLoadingIndicator() {
    setState(() {
      showLoading = false;
    });
  }
  GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();

  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800], // Set background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Set border radius
        ),
        title: Text(textAlign: TextAlign.center,'Are you sure?', style: TextStyle(color: Colors.white),),
        content: Text(textAlign: TextAlign.center,'Do you want to exit the app?', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 16), // Adjust the width as needed
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // Close the app
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],


      ),
    )) ??
        false;
  }
  Widget build(BuildContext context) {
    // bool showDateContainers = false;
    pi = pi?.replaceAll('%', '') ?? '0';


    double piValue = double.tryParse(pi!) ?? 0.0;


    double remainingPercentage = 100 - piValue;
    remainingPercentage = double.parse(remainingPercentage.toStringAsFixed(2));


    return new WillPopScope(

        onWillPop: _onWillPop,
        child:new
         Scaffold(
     // backgroundColor: Colors.green[100],
      key: scaffoldKey2,
      appBar: MyAppBar(

        title: "Dashboard",

        ontapmenu: () {
          if (scaffoldKey2.currentState!.isDrawerOpen) {
            // If the drawer is open, close it by popping the drawer route
            Navigator.of(context).pop();
          } else {
            // If the drawer is not open, open it
            scaffoldKey2.currentState?.openDrawer();
          }
        },


        onTapLogout: () async {
          showLogoutConfirmationDialog(context);

        },

      ),

      drawer: CustomDrawer(),


      body:
      isloading
       // Check loading state

          ? Center(
        child: CircularProgressIndicator(color: Colors.green,), // Show a loading indicator
      )

          :

      Column(

        children: [

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Your existing Containers
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green[800]!,
                            Colors.green[400]!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green[800] ?? Colors.white,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text("${DateFormat.yMd().format(DateTime.now())}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
    Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    Colors.green[800]!,
    Colors.green[400]!,
    ],
    ),
    boxShadow: [
    BoxShadow(
    color: Colors.green[800] ?? Colors.white,
    blurRadius: 1,
    offset: Offset(0, 2),
    ),
    ],
    ),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    // Year Dropdown
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
      child: Text(
      'Year',
      style: TextStyle(color: Colors.white),
      ),
      ),
    ),
    DropdownButton<String>(
    items: years.map((String value) {
    return DropdownMenuItem<String>(
    value: value,

    child: Text(value, style: TextStyle(color: Colors.white)),
    );
    }).toList(),
    onChanged: (String? newValue) async{
    setState(() {
    selectedYear = newValue!;
    Year=selectedYear;
    });
    await fetchDataAndUpdateState(Year+Month);
    },
    value: selectedYear,
    dropdownColor: Colors.green[800],
    ),
    ],
    ),
    SizedBox(width: 8),
    // Month Dropdown
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      Center(
      child: Text(
      'Month',
      style: TextStyle(color: Colors.white),
      ),
      ),
      DropdownButton<String>(
      items: List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'))
          .map((String value) {
      return DropdownMenuItem<String>(
      value: value,
      child: Text(value, style: TextStyle(color: Colors.white)),
      );
      }).toList(),
        onChanged: (String? newValue) async {
          setState(() {
            selectedMonth = newValue!;
            Month = selectedMonth;
          });
          print(Year + Month);
          await fetchDataAndUpdateState(Year + Month);
        },

        value: selectedMonth,
      dropdownColor: Colors.green[800],
      ),
      ],
      ),
    ),

    ],
    ),
    ),


                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green[800]!,
                            Colors.green[400]!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green[800] ?? Colors.white,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text("$currentTime",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // DropdownButton for Year and Month

                  ],
                )

              ),
            ],
          ),

    Expanded(
                  child: Container(


                    decoration: BoxDecoration(
                      //color: Colors.green.shade100,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(500), bottomRight: Radius.circular(20)),
                    ),

                    child:

                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        sections: (piValue > 100)
                            ? [
                          PieChartSectionData(
                            color: Colors.green,
                            value: piValue,
                            title: '$piValue%',
                            radius: 50,
                            titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ]
                            : List.generate(
                          2,
                              (index) => PieChartSectionData(
                            color: index == 0 ? Colors.green : Colors.red,
                            value: index == 0 ? piValue : remainingPercentage,
                            title: '${index == 0 ? piValue : remainingPercentage}%',
                            radius: 50,
                            titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    )

                  ),
                  ),

    //       SizedBox(height: 12),
    //
    //
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //
    //     children: [
    //
    //       Expanded(child: CustomGradientContainer( text: 'Achievement Percentage', value: piValue, gradientStartColor: Colors.green[800]?? Colors.green, gradientEndColor: Colors.green )),
    //       SizedBox(width: 5,),
    //
    //       if(remainingPercentage>0)
    //
    //         Expanded(child: CustomGradientContainer( text: 'Remaining Percentage', value: remainingPercentage, gradientStartColor: Colors.red, gradientEndColor: Colors.red,)),
    //
    //
    //
    //         // Row(
    //         //   mainAxisAlignment: MainAxisAlignment.center,
    //         //   children: [
    //         //     Text(
    //         //       'Extra Achievement Percentage: ',
    //         //       style: TextStyle(color: Colors.blue, fontSize: 16),
    //         //     ),
    //         //     Text(
    //         //       '${-remainingPercentage}%',
    //         //       style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
    //         //     ),
    //         //   ],
    //         // ),
    //     ],
    //   ),
    // ),





          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Use Axis.vertical if needed
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (salev10.isNotEmpty)
                      AnimatedAttractiveCard(
                        title: "Month Sale",
                        value: salev10.toString(),
                      ),
                    if (salev10.isEmpty)
                      AnimatedAttractiveCard(
                        title: "Month Sale",
                        value: "0",
                      ),
                    //Image.asset('assets/vs2.png', width: 40, height: 40, color: Colors.green[800]),
                    if (target.isEmpty)
                      AnimatedAttractiveCard(
                        title: "Month Target",
                        value: '0',
                      ),
                    if (target.isNotEmpty)
                      AnimatedAttractiveCard(
                        title: "Month Target",
                        value: target,
                      ),
                  ],
                ),
              ],
            ),
          ),





          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              //color: Colors.green[800],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        customer=false;
                        showChildren = true;
                        //stackItems.add(reporting);
                        _loadUserDetails(reporting);
                        stackItems.clear();

                        //stackItems.add(reporting);
                        for (final id in checkboxStates.keys) {
                          checkboxStates[id] = false;
                        }

                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0),
                      decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.circular(16)),

                      child:
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  Container(
                          decoration: BoxDecoration(  boxShadow: [
                            BoxShadow(
                              color:
                          Colors.red,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],

                          ),
                          child: Text(
                            'Root:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                            ),
                          ),

                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: stackItems
                              .asMap()
                              .map((index, stackItem) {
                            final stackItemTitle = UserDetails(
                                empName: stackItem.empName,
                                empCode: stackItem.empCode,
                                reportingTo: stackItem.reportingTo,
                                designation: stackItem.designation,
                                isCheck: false
                            ).empName
                            ;
                            return MapEntry(
                              index,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    color: index == stackItems.length - 1
                                        ? Colors.green[800]?? Colors.white
                                        : Colors.green.shade100,
                                    border: Border.all(
                                      color: index == stackItems.length - 1
                                          ? Colors.green.shade100
                                          : Colors.green.shade100
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        index == stackItems.length - 1
                                            ?  Colors.green[800]?? Colors.green.shade100
                                            : Colors.green[800]?? Colors.white,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(

                                    onTap: () {
                                      _loadUserDetails(stackItem.empCode,
                                          );
                                      setState(() {

                                        total;
                                        // _loadUserDetails(stackItemTitle);
                                        // print(stackItemTitle);
                                        for (int i = index + 1;
                                        i < stackItems.length;
                                        i++) {
                                          final idToRemove =
                                              stackItem.empCode;
                                          checkboxStates[idToRemove] =
                                          false;

                                          //print(stackItem.empCode);
                                        }

                                        stackItems.removeRange(
                                            index + 1, stackItems.length);

                                        //print(stackItem);

                                      });

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        stackItemTitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          index == stackItems.length - 1
                                              ? FontWeight.w500 : FontWeight
                                              .normal,

                                          color:
                                          index == stackItems.length - 1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                              .values
                              .toList(),


                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(

            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              children: [
                // Only show the initial hierarchy if the flag is set

                buildHierarchyTree(),
              ],
            ),
          ),





    ])));


  }}




















class AnimatedGradient extends StatefulWidget {
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  late Gradient currentGradient;

  @override
  void initState() {
    super.initState();
    currentGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.green[200]!, Colors.green[100]!],
    );
  }



  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: currentGradient,
      ),
    );
  }
}

class AnimatedAttractiveCard extends StatelessWidget {

  final String title;
  final String value;

  AnimatedAttractiveCard({

    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      color: Colors.green[800],
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle card tap, e.g., navigate to a new screen
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5.0),
              AnimatedText(value),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;

  AnimatedText(this.text);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  late String currentText;

  @override
  void initState() {
    super.initState();
    currentText = widget.text;
  }

  @override
  void didUpdateWidget(covariant AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != currentText) {
      setState(() {
        currentText = widget.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return
          //opacity: value,

          Text(
              currentText,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ));
      },
    );
  }}