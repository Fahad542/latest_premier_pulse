import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import 'package:share/share.dart';
import '../../../model/branch_model.dart';
import '../../../model/dsf_measure_model.dart';
import '../../../model/heirarchy_model.dart';
import '../../../model/team_company.dart';
import '../../../respository/dsf_meansure_repository.dart';
import '../../../respository/measure_repository.dart';
import '../../../respository/sales_repository.dart';
import '../../../utils/Drawer.dart';
import '../../../utils/customs_widgets/Custom_app_bar.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/No_data.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import '../../../utils/customs_widgets/list_filters.dart';
import '../../../utils/utils.dart';
import 'Dsf_route.dart';
import 'Sales_viewmodel.dart';

class Team_analysis extends StatefulWidget {
  @override
  State<Team_analysis> createState() => _Team_analysisState();
}

class _Team_analysisState extends State<Team_analysis> {
  @override

  final salesViewModel = SalesHeirarchyViewModel();
  List<UserDetails> userDetailsList = [];
  bool showDateContainers=false;
  bool sortwithzero=false;
  List<UserDetails> rootlist = [];
  List<dynamic> apiResponseList =[];
  List<int> companynumbers=[];
  String sale='';
  List<Team_compnay> team = [];
  List<Branch_compnay> branch = [];
  String salesid='';
  DateTime? startDate=  DateTime( DateTime.now().year, DateTime.now().month, 1 );
  DateTime? endDate= DateTime.now();
  String? startDateFormatted;
  String? endDateFormatted;
  List<String> concatenatedList = [];
  List<String> concatenatedListbranch = [];
  List<String> concatenatedcode = [];
  List<String> selectedValue=[];
  List<bool> checkcompany = [];
  List<bool> checkbranch = [];
  List<bool> checkcbranch = [];
  String formattedStartDate='';
  String formattedEndDate='';
  List<int> branchnumbers=[];
  List<String> comapnycodelist=[];
  List<String> branchcodelist=[];
  var filteredSalesData;
  bool showsales=false;
  List<String> selectedmeasures=[];
  List<bool> checkboxlist=[];
  String totalsale='';
  int totals=0;
  final formatter = NumberFormat('#,###');
  bool isloading = false;

  @override

  void initState() {
    totalsale="0";
    setState(() {
      startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      formattedStartDate = startDateFormatted!;  // Assign to formatted variable
      formattedEndDate = endDateFormatted!;      // Assign to formatted variable
      print("date ${startDateFormatted}");
    });
    final repository = measure_repository();
    repository.getAllMeasures();
    super.initState();
    _loadUserDetails(empcode.auth,'1');

    teamcompany();
    branchcompany();

  }
  void showfitler() async {

    await salesViewModel.initializeDatabase();
    await salesViewModel.fetchdata();
    await salesViewModel.fetchbranchdata();
    setState(() {
      try {

        salesViewModel.showDropdownCheckboxs(
          context,
          concatenatedListbranch,
          concatenatedList,
          selectedValue,
          "Select Companies",
          checkcompany,
          checkbranch,
              (selectedValue) {
            comapnycodelist = selectedValue;
            print('Selected Values: $checkbranch');
          },
              (selectedValue) {
            branchcodelist = selectedValue;

            print('Selected Values: $branchcodelist');
          },

              () async {
            try {
              branchnumbers = branchcodelist.map((part) => int.parse(part.replaceAll('"', ''))).toList();
              companynumbers = comapnycodelist.map((code) => int.parse(code)).toList();
             await getsales(salesid);

            } catch (error) {
              print('API Error: $error');
              Utils.snackBarred("Error to load data", context);
              Navigator.of(context).pop(); // Close loading dialog
            }
          },

        );
      } catch (error) {
        // Handle UI/dialogue box error
        print('UI Error: $error');
      }
    });

  }
  Future<void> branchcompany() async {
    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.fetchbranchdata();


    setState( (){
      branch=data;
      for (final item in branch) {
        String concatenatedString = "${item.BranchName} - ${item.BranchID}";
        concatenatedListbranch.add(concatenatedString);
        checkbranch.add(item.ischecked);
      }} );
  }
  Future<void> teamcompany() async {

    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.fetchdata();

    setState(() {
      team=data;
      for (final item in team) {
        String concatenatedString = "${item.companyID} - ${item.companyName}";
        concatenatedList.add(concatenatedString);
        concatenatedcode.add(item.companyName);
        checkcompany.add(item.ischecked);
      }});
  }
  Future<void> _loadUserDetails(String reporting, String repto) async {

    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.select(reporting,repto);
    setState(() {
      userDetailsList = data;
    });
    print("Data: ${data}");
  }
  Future<void> getsales(String empcode) async {
    setState(() {
      startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      formattedStartDate = startDateFormatted!; // Assign to formatted variable
      formattedEndDate = endDateFormatted!;
      isloading = true;
    });
    try {
      apiResponseList = await SalesRepository().fetchData(
          empcode,
          formattedStartDate,
          formattedEndDate,
          companynumbers,
          branchnumbers,
          selectedmeasures);

      setState(() {
        totals = 0;
        for (int i = 0; i < apiResponseList.length; i++) {
          double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
          totals += salesValue.round();
        }
        totalsale = formatter.format(totals);
      });
      setState(() {
        isloading = false;
      });
    }
    catch (e, stackstarce) {
      Utils.toastMessage(e.toString());
      setState(() {

        apiResponseList = [];
        isloading = false;
      });
      print(stackstarce);
      print(e.toString());
    }
  }
  Widget _buildDataRow(String heading, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                '$heading:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Text(
                value,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,

                ),
              ),
            ),
          ],
        ),
      
    );
  }
  final dsfMeasureRepository = dsf_measure_Repository();
  List<DsfMeasureModel>  data= [];
  bool dsfLoading = false;
  Future<List<DsfMeasureModel>> fetchData(String dsfCode) async {

    try {
      data = await dsfMeasureRepository.fetchData(
        formattedStartDate,
        formattedEndDate,
        int.parse(dsfCode),
      );

      return data;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
  String formatNumber(String? number) {
    if (number == null || number.isEmpty) {
      return 'N/A';
    }

    double? parsedNumber = double.tryParse(number);

    if (parsedNumber == null) {
      return 'Invalid number';
    }


    parsedNumber = double.parse(parsedNumber.toStringAsFixed(0));

    final numberFormat = NumberFormat('#,##');
    return numberFormat.format(parsedNumber);
  }

  void bottomsheet(BuildContext context, String code, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // 90% of screen height
        child:
          FutureBuilder<List<DsfMeasureModel>>(
          future: fetchData(code), // Call your async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(

                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.greencolor,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            } else {
              List<DsfMeasureModel> data = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Close button
                    Container(
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.greencolor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var item = data[index];
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                            Column(
                              children: [
                                _buildDataRow('Name', item.dsfDsfName),
                                _buildDataRow('SAF Customer', item.safCustomer.toString()),
                                _buildDataRow('Avg Sku Per Bill', item.avgSkuPerBill?.toStringAsFixed(2) ?? '0.00'),
                                _buildDataRow('DSF SAF BusinessLine', item.dsfSafBusinessLine),
                                _buildDataRow('Duration', item.duration.toString()),
                                _buildDataRow('Eco Percentage', item.ecoPercentage),
                                _buildDataRow('First Order', item.firstOrder != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.firstOrder!)) : 'N/A',),
                                _buildDataRow('Last Order', item.lastOrder != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.lastOrder!)) : 'N/A'),
                                _buildDataRow('Productive Customer', item.productiveCustomer.toString()),
                                _buildDataRow('DSF Target Days Remaining', item.DSFTargetDaysDSFRemaining.toString()),
                                _buildDataRow('DSF Target Days Worked', item.DSFTargetDaysDSFWorked.toString()),
                                _buildDataRow('DSF Target Value', formatNumber(item.DSFTarget_Value.toString())),
                                _buildDataRow('DSFTarget %', item.DSFTarget.toString()),
                                _buildDataRow('DSF Target Remaining', formatNumber(item.DSFTarget_Remaining.toString())),
                                _buildDataRow('DSF Target Per Day Required', formatNumber(item.DSFTarget_Per_Day_Required.toString())),
                                _buildDataRow('DSF Target Expected Landing', formatNumber(item.DSFTarget_Expected_Landing.toString())),
                                _buildDataRow('Booking Quantity', formatNumber(item.Booking_Quantity.toString())),
                                _buildDataRow('Booking Value Inc ST', formatNumber(item.Booking_Value_Inc_ST.toString())),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

            }
          },
          ) );
      },
    );
  }

  late GoogleMapController _controller;
  Set<Marker> _markers = Set();
  final LatLng _initialPosition = LatLng(37.7749, -122.4194);  // San Francisco Coordinates

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }











  @override
  Widget build(BuildContext context) {
    return
            WillPopScope(
              onWillPop: () async {
                return await Exit.showExitDialog(context);
              },
              child: Scaffold(
          appBar:
          CustomAppBar(
              title: 'Team Analysis',

              actions: [
                Icon(Icons.abc, color: AppColors.greencolor,),
                if(showsales ==true)
                  MyPopupMenu(
                    menuItems: [
                      MenuItem(
                        text: 'Share',
                        icon: Icons.share,
                        value: 'share',
                        onTap: () {
                          print('Share selected');
                          // Add your custom action here
                        },
                      ),
                      MenuItem(
                          text: 'Measures',
                          icon: Icons.filter_list,
                          value: 'measures',
                          onTap: () {

                          }
                      ),
                      MenuItem(
                        text: 'Filters',
                        icon: Icons.filter_list,
                        value: 'filters',
                        onTap: () {
                          print('Filters selected');
                          // Add your custom action here
                        },
                      ),
                      MenuItem(
                        text: sortwithzero == false ? 'With 0s' : 'Without 0s', // Correct use of ternary operator
                        icon: Icons.list,
                        value: 'zero',
                        onTap: () {
                          print(sortwithzero ? 'With 0s' : 'Without 0s');
                          // Add your custom action here
                        },
                      )
                    ],
                    onSelected: (value) {

                      if (value == "measures") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return filters(
                              onSelectionDone: (selectedValues) async {
                                setState(() {
                                  selectedmeasures = selectedValues.toList();
                                });

                                DateFormat dateFormat = DateFormat('yyyy,MM,dd');
                                formattedStartDate = dateFormat.format(startDate!);
                                formattedEndDate = dateFormat.format(endDate!);
                                await getsales(salesid);
                                setState(() {
                                  apiResponseList = apiResponseList;
                                });
                              },
                              selectedvalues: selectedmeasures,
                            );
                          },
                        );
                      }

                      if (value == 'share') {
                        String combinedMessage = "Start Date: $formattedStartDate\nEnd Date: $formattedEndDate\n\n";

                        for (int i = 0; i < apiResponseList.length; i++) {
                          if (apiResponseList[i]['EmpCode'].isNotEmpty) {
                            String name = apiResponseList[i]['EmpName'];
                            String id = apiResponseList[i]['EmpCode'].toString();
                            String sale = NumberFormat('#,###').format(double.parse(apiResponseList[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));
                            sale = sale.isEmpty ? '0' : sale;

                            String measure = ''; // Reset measure for each iteration
                            measure += List.generate(selectedmeasures.length, (index) {
                                final measure = selectedmeasures[index];
                                final teamValue = apiResponseList[i][measure.toString().replaceAll(' ', '_')];
                                final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                                return "$measure: $formattedValue";
                              },
                            ).join('\n');


                            combinedMessage += "Name: $name\nID: $id\nSale: $sale\n$measure\n\n";
                          }
                        }

                        Share.share(combinedMessage, subject: 'Sales Information');
                      }

                      if (value == "filters") {
                        showfitler();
                      }

                      if (value == "zero") {
                        setState(() {
                          sortwithzero = !sortwithzero;
                        });
                      }
                    },

                  ),

              ],
          ),
          drawer: CustomDrawer(),
          body:


          isloading
                ?    shimmer_effect( isLoading: isloading , selectedmeasures: selectedmeasures,)

                :
                    Stack(
                      children:[
                        SizedBox(height: 20,),
                        Column(
                          children: [
                            TotalSalesCard(totalSale: totalsale.toString(), title: 'Total Sales',),
                            if(showsales ==true)
                            SizedBox(height: 30,),
                            Expanded(child:
                            Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14.0),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 25,),


                                            Container(
                                              height:40,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: AppColors.primary),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showsales = false;
                                                        totalsale = '0';
                                                        _loadUserDetails(empcode.auth, '1');
                                                        rootlist.clear();
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Root',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      physics: BouncingScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,

                                                          children: rootlist.asMap().map((index, stackItem) {


                                                            if (index == rootlist.length - 1) {
                                                              salesid = stackItem.empCode;
                                                            }
                                                            final stackItemTitle = UserDetails(
                                                                empName: stackItem.empName,
                                                                empCode: stackItem.empCode,
                                                                reportingTo: stackItem.reportingTo,
                                                                designation: stackItem.designation,
                                                                isCheck: false
                                                            ).empName;
                                                            final stackItemdes = UserDetails(
                                                                empName: stackItem.empName,
                                                                empCode: stackItem.empCode,
                                                                reportingTo: stackItem.reportingTo,
                                                                designation: stackItem.designation,
                                                                isCheck: false
                                                            ).designation;

                                                            return MapEntry(

                                                              index,
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 0),
                                                                child: Row(

                                                                  children: [

                                                                    Container(
                                                                      width: 80,

                                                                      decoration: BoxDecoration(
                                                                        color: index == rootlist.length - 1
                                                                            ? AppColors.primary
                                                                            : Colors.white,


                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: GestureDetector(

                                                                        onTap: ()  async {

                                                                          _loadUserDetails(stackItem.empCode,stackItem.reportingTo);
                                                                          setState(()
                                                                          {
                                                                            showsales = false;
                                                                            totalsale = '0';
                                                                            rootlist.removeRange(index + 1, rootlist.length);
                                                                            showsales = false;

                                                                          });

                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(2.0),
                                                                          child:
                                                                          Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                stackItemTitle,
                                                                                style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  fontWeight:
                                                                                  index == rootlist.length - 1
                                                                                      ? FontWeight.w600 : FontWeight
                                                                                      .normal,

                                                                                  color: index == rootlist.length - 1
                                                                                      ? Colors.white
                                                                                      : Colors.black,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                              SizedBox(height: 3,),
                                                                              Text(' $stackItemdes', style: TextStyle(fontSize:11, color: index == rootlist.length - 1
                                                                                  ? Colors.white
                                                                                  : Colors.black,

                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          ).values.toList().reversed.toList(),


                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16.0),
                                            if (showsales == false)

                                              (userDetailsList.length > 0)
                                                ? Expanded(
                                              child: ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                itemCount: userDetailsList.length,
                                                itemBuilder: (BuildContext context, index) {
                                                  var data = userDetailsList[index];


                                                  return Padding(
                                                    padding:  EdgeInsets.all(0.0),
                                                    child: HeirarchyCard(
                                                      personwise: true,
                                                      title: data.empName,
                                                      date: data.empCode,
                                                      amount: sale,
                                                      color: Colors.green,
                                                      designation: data.designation,
                                                      onTap: () {
                                                        setState(() {
                                                          if (showsales == true) {
                                                            getsales(data.empCode);
                                                          }
                                                          rootlist.add(
                                                              UserDetails(
                                                              empCode: data.empCode,
                                                              empName: data.empName,
                                                              reportingTo: data.reportingTo,
                                                              designation: data.designation,
                                                              isCheck: data.isCheck));
                                                          _loadUserDetails(data.empCode, '0');
                                                        });
                                                      },
                                                      saleonTap: () {
                                                        setState(()
                                                        {
                                                          rootlist.add(UserDetails(
                                                              empCode: data.empCode,
                                                              empName: data.empName,
                                                              reportingTo: data.reportingTo,
                                                              designation: data.designation,
                                                              isCheck: data.isCheck));
                                                          showsales = true;
                                                          getsales(data.empCode);
                                                        });
                                                      },
                                                      showsale: showsales,
                                                      selectedmeasures: selectedmeasures, item: {},

                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                                : Container(
                                              height: 400,
                                              child: Nodata(),
                                            ),
                                            if (  showsales == true )

                                              SalesListView(
                                                sortdata:sortwithzero == false ? 'With Zero' : 'Without Zero',
                                                  apiResponseList: apiResponseList,

                                                 customCardWidget:( data )  {
                                                   return
                                                     HeirarchyCard(
                                                       personwise: true,
                                                       title: data['EmpName'].toString(),
                                                       date: data['EmpCode'].toString(),
                                                       amount: data['Sales_Inc_ST'].toString(),
                                                       color: AppColors.greencolor,
                                                       designation: data['EmpDesignation'].toString(),
                                                       kpionTap: (){
                                                         bottomsheet(context,data['EmpCode'],data['EmpName']);

                                                       },
                                                         route: ()
                                                         {
                                                         Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(dsfcode: data['EmpCode'].toString(), date: endDateFormatted.toString(), name: data['EmpName'].toString(), code: data['EmpCode'].toString(),)));
                                                         //dsf_route(context);
                                                         },
                                                       onTap: () async
                                                       {
                                                        if(data['EmpDesignation'] == "DSF")
                                                          {
                                                            salesViewModel.showCustomerWiseDialog(
                                                                context,
                                                                data['EmpCode'] ,
                                                                formattedStartDate,
                                                                formattedEndDate,
                                                                data['EmpName'],
                                                                companynumbers,
                                                                branchnumbers,
                                                                selectedmeasures);
                                                          }
                                                        if(data['EmpDesignation'] != "DSF")
                                                          {
                                                          await getsales(data['EmpCode']);
                                                          setState(() {
                                                            rootlist.add(
                                                              UserDetails(
                                                                  empCode: data['EmpCode'],
                                                                  empName: data['EmpName'],
                                                                  reportingTo: data['ReportTo'],
                                                                  designation: data['EmpDesignation'],
                                                                  isCheck: false),
                                                            );
                                                          });
                                                          }
                                                          },

                                                      showsale: showsales,
                                                      selectedmeasures: selectedmeasures,
                                                      item: data,
                                                      saleonTap: ( )
                                                         { }

                                                    );


                                                },
                                              ),




    ])))]),

                        if(showsales ==true)


                          Positioned(
                              top: 130,
                              right: 0,
                              left: 0,

                              child:
                              DateRangeSelector(
                                startDate: startDate, endDate: endDate,
                                showDateContainers: true,
                                onStartDateSelected: (date ) {
                                  setState(() {
                                    startDate = date;
                                    // Print the selected start date
                                    print("Start Date selected: $startDate");

                                    // Check if the start date is valid
                                    if (startDate!.isAfter(endDate!)) {
                                      // Show an error message to the user using a Snackbar
                                      Utils.toastMessage("Start date cannot be after the end date");
                                    } else {
                                      // Only call API if startDate is before or equal to endDate
                                      getsales(salesid);
                                    }
                                  });
                                }, onEndDateSelected: (date ) {
                                setState(() {
                                  endDate = date;
                                  // Print the selected end date
                                  print("End Date selected: $endDate");

                                  // Check if the end date is valid
                                  if (endDate!.isBefore(startDate!)) {
                                    // Show an error message to the user using a Snackbar
                                    Utils.toastMessage("End date cannot be before the start date");

                                  } else {
                                    // Only call API if endDate is after or equal to startDate
                                    getsales(salesid);
                                  }
                                });
                              },
                              )

                          ),
                      ]
                    )
              ),
            );
  }
}

















