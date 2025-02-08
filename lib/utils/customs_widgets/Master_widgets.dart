import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/color.dart';
import '../utils.dart';
import 'No_data.dart';
import 'Pe_chart.dart';

class HeirarchyCard extends StatefulWidget {
  final String title;
  final String date;
  final String amount;
  final Color color;
  final String designation;
  final VoidCallback onTap;
  final VoidCallback saleonTap;
   VoidCallback? kpionTap;
  VoidCallback? route;
  VoidCallback? getchannels;
  VoidCallback? getbranches;
   String? phone;
   String? lat;
  String? long;
   bool check=false;
  final Map<String, dynamic> item;
  final List<String> selectedmeasures;
  bool showsale;
  bool personwise;
  String? classname;

  HeirarchyCard({
    this.phone,
    this.check =false,
    this.classname ='',

    this.lat,
    this.long,
    this.kpionTap,
    this.route,
    required this.title,
    required this.date,
    required this.amount,
    required this.color,
    required this.designation,
    required this.onTap,
    required this.saleonTap,
    this.getbranches,
    this.getchannels,
    required this.showsale,
    this.personwise = false,
    required this.selectedmeasures,
    required this.item,
  });

  @override
  _HeirarchyCardState createState() => _HeirarchyCardState();
}

class _HeirarchyCardState extends State<HeirarchyCard> {
  final NumberFormat formatter = NumberFormat('#,###');

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Column(
        children: [

          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                if(widget.personwise ==true)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.black],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.title,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    TextSpan(
                                      text: widget.date.isNotEmpty ? "(${widget.date})" : '',  // Only show if date is not empty
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              if(widget.designation != '')
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if(widget.designation != '')
                                  Text(
                                    widget.designation,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      // fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  if(widget.designation == '')
                                  Text(''),
                                  Visibility(
                                    visible: widget.showsale,
                                    child: Row(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.only(top: 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "RS ${widget.amount}/=",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Back button for sale view

                            Visibility(
                              visible: !widget.showsale,
                              child: InkWell(
                                onTap: widget.saleonTap,
                                child: Image.asset(
                                  "assets/cash.png",
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                            ),


                      ],
                    ),
                  ),
                  if(widget.personwise ==false)
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.title,
              overflow: TextOverflow.ellipsis, // Prevents overflow and shows "..."
              maxLines: 1,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              // Limits the text to a single line
            ),
            if(widget.date.isNotEmpty)
            SizedBox(height: 2,),
            if(widget.date.isNotEmpty)
            Text(
              ("(${widget.date})"),
              overflow: TextOverflow.ellipsis, // Prevents overflow and shows "..."
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              // Limits the text to a single line
            ),
          ],
        ),
      ),

      Text(
      "RS ${widget.amount}/=",
      style: TextStyle(
        fontSize: 16,
        color: Colors.red,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],),
),
                  if(widget.classname == "Company")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(
                        onTap: widget.getchannels,
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.greencolor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Get Channels",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontStyle: FontStyle.italic,),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: widget.getbranches,
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.greencolor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Get Branches",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontStyle: FontStyle.italic,),
                          ),
                        ),
                      ),

                    ],
                  ),
                  // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12),
                    //     color: AppColors.greencolor,
                    //
                    //   ),
                    //   child: Text("See KPIS", style: TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic,),),),



                  if (widget.selectedmeasures.isNotEmpty)
               SizedBox(height: 6,),

                  if (widget.selectedmeasures.isNotEmpty)
                    Wrap(
                      spacing: 8.0, // Horizontal space between measures
                      runSpacing: 4.0, // Vertical space between wrapped lines
                      children: List.generate(widget.selectedmeasures.length, (index) {
                        var selectedMeasureKey = widget.selectedmeasures[index].replaceAll(' ', '_');
                        var itemValue = widget.item[selectedMeasureKey];
                        var formattedValue = itemValue is num ? formatter.format(itemValue).toString() : '0';

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.primary.withOpacity(0.1),

                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${widget.selectedmeasures[index]}: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                itemValue != null
                                    ? (itemValue is String && itemValue.endsWith('%') ? itemValue : formattedValue)
                                    : '0',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greencolor,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,

                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),



        ],
      ),
        if (widget.designation == "DSF" && widget.showsale == true)
          Positioned(
            right: 8,
            left: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                InkWell(
                  onTap: widget.kpionTap,
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.greencolor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "DSF KPIS",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, fontStyle: FontStyle.italic,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.designation == "DSF" && widget.showsale == true)
          Positioned(
right: 60,
            left: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                InkWell(
                  onTap: widget.route,
                  child: Container(

                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.greencolor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Booking Map",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, fontStyle: FontStyle.italic,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Positioned(
          //      right: 8,
          //       left: 2,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //
          //           InkWell(
          //             onTap: widget.kpionTap,
          //             child: Container(
          //
          //               padding: EdgeInsets.all(6.0),
          //               decoration: BoxDecoration(
          //                 gradient: LinearGradient(
          //                   colors: [AppColors.primary, AppColors.greencolor],
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                 ),
          //                 borderRadius: BorderRadius.circular(10.0),
          //               ),
          //               child: Text(
          //                 "DSF KPIS",
          //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontStyle: FontStyle.italic,),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //    SizedBox(width: 5,),
          //     Positioned(
          //       right: 4,
          //       left: 2,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //
          //           InkWell(
          //             onTap: widget.kpionTap,
          //             child: Container(
          //               padding: EdgeInsets.all(6.0),
          //               decoration: BoxDecoration(
          //                 gradient: LinearGradient(
          //                   colors: [AppColors.primary, AppColors.greencolor],
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                 ),
          //                 borderRadius: BorderRadius.circular(10.0),
          //               ),
          //               child: Text(
          //                 "DSF KPIS",
          //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontStyle: FontStyle.italic,),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

        if (widget.check == true)
    Positioned(

    right: 8,
    left: 2,

    child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    if (widget.phone != "")
                      Tooltip(
                        message: "Call",
                        child: InkWell(
                          onTap: () {
                            launch('tel:${widget.phone.toString().replaceFirst('92', '0')}');
                          },
                          child:


                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.primary, // Background color with opacity
                              borderRadius: BorderRadius.circular(8), // Rounded corners

                            ),
                            child: Icon(Icons.phone, color: Colors.white, size: 18,), // Icon inside the container
                          )

                        ),
                      ),

                    if (widget.lat != null && widget.long != null)
                      SizedBox(width: 5),
                    if (widget.lat != null && widget.long != null)
                      Tooltip(
                        message: "Location",
                        child: InkWell(
                          onTap: () {
                            launch('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
                          },
                          child:  Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.primary, // Background color with opacity
                              borderRadius: BorderRadius.circular(8), // Rounded corners

                            ),
                            child: Icon(Icons.location_on, color: Colors.white, size: 18,), // Icon inside the container
                          )
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        if (widget.classname == "Company")
          SizedBox(height: 5,),









     ]
    );
  }
}

class TotalSalesCard extends StatelessWidget {
  final String totalSale; // You can replace this with any other data type you need
  final String title;

  // Constructor to pass the total sale value
  const TotalSalesCard({
    Key? key,
    required this.totalSale,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.greencolor, // Assuming AppColors is a predefined class
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Rs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "$totalSale",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class TotalSalesCardwithpie extends StatelessWidget {
  final String totalSale; // You can replace this with any other data type you need
  final String title;

  // Constructor to pass the total sale value
  const TotalSalesCardwithpie({
    Key? key,
    required this.totalSale,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: AppColors.greencolor, // Assuming AppColors is a predefined class
      ),
      child: Column(
        children: [
          Container(
              height: 180,

              child: Chart()),
          SizedBox(height: 25),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Rs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "$totalSale",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}























class DateRangeSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  Color? color;
  final bool showDateContainers;
  final Function(DateTime) onStartDateSelected;
  final Function(DateTime) onEndDateSelected;

  DateRangeSelector({
    Key? key,
    this.color = Colors.white,
    required this.startDate,
    required this.endDate,
    required this.showDateContainers,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 68,
        width: 30,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DateContainer(
              title: "Start Date",
              range: "yyyy-MM-dd",
              selectedDate: startDate,
              isVisible: true,
              onDateSelected: (date) {
                if (endDate != null && date.isAfter(endDate!)) {
                  Utils.flushBarErrorMessage("Start date cannot be after end date!", context);

                } else {
                  onStartDateSelected(date);
                }
              },
            ),
            DateContainer(
              title: "End Date",
              range: "yyyy-MM-dd",
              selectedDate: endDate,
              isVisible: true,
              onDateSelected: (date) {
                if (startDate != null && date.isBefore(startDate!)) {
                  Utils.flushBarErrorMessage("End date cannot be before start date!", context);

                } else {
                  onEndDateSelected(date);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



class SalesListView extends StatefulWidget {
  String? sortdata;
  var apiResponseList;
  final Widget Function(Map<String, dynamic>) customCardWidget;

  SalesListView({
    Key? key,
    this.sortdata,
    required this.apiResponseList,
    required this.customCardWidget,
  }) : super(key: key);

  @override
  _SalesListViewState createState() => _SalesListViewState();
}

class _SalesListViewState extends State<SalesListView> {
  var sortedApiResponseList;
  var sortedApiResponseListWithoutZeros;
  final formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    sortedApiResponseList = List.from(widget.apiResponseList);
    sortedApiResponseListWithoutZeros = List.from(widget.apiResponseList);
    sortData(); // Call the sort function to sort data initially
  }

  void sortData() {
    sortedApiResponseList.sort((a, b) {
      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      double aSales = double.tryParse(aSalesStr) ?? 0;
      double bSales = double.tryParse(bSalesStr) ?? 0;
      return bSales.compareTo(aSales);
    });
    for (var data in sortedApiResponseList) {
      var formattedSales = formatter.format(double.tryParse(data['Sales_Inc_ST']?.toString() ?? '0') ?? 0);
      data['Sales_Inc_ST'] = formattedSales; // Replace original sales value with formatted value
    }
    sortedApiResponseListWithoutZeros = sortedApiResponseList.where((item) {
      String salesStr = item['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      double sales = double.tryParse(salesStr) ?? 0;
      return sales > 0;
    }).toList();

    // Format the sales value for the list with zeros

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.apiResponseList.isNotEmpty
          ? widget.sortdata == "With Zero"
          ? ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: sortedApiResponseList.length,
        itemBuilder: (BuildContext context, int index) {
          var data = sortedApiResponseList[index];
          return widget.customCardWidget(data); // Using the custom card widget passed in
        },
      )
          : widget.sortdata == "Without Zero"
          ? ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: sortedApiResponseListWithoutZeros.length,
        itemBuilder: (BuildContext context, int index) {
          var data = sortedApiResponseListWithoutZeros[index];
          return widget.customCardWidget(data); // Using the custom card widget passed in
        },
      )
          : Container() // Handle the case when `sortdata` is neither "with zeros" nor "without zeros"
          : Container(
        height: 400,
        child: Nodata(), // Handle no data state
      ),
    );
  }
}





class MasterView extends StatefulWidget {
  bool totalsaleswithchart;
  String title;
  String? sortdata;
  var apiResponseList;
  DateTime? startDate;
  DateTime? endDate;
  VoidCallback? rootontap;
  void Function(int)?  stackontap;
  VoidCallback? totalsaleTap;
  List<Map<String, dynamic>>? rootlist;
  final Widget Function(Map<String, dynamic>) customCardWidget;

  // Add the new callback parameters for start and end date selection
  final void Function(DateTime) onStartDateSelected;
  final void Function(DateTime) onEndDateSelected;

  MasterView({
    this.totalsaleswithchart=false,
    required this.title,
    Key? key,
    this.sortdata,
    this.totalsaleTap,
    this.rootlist,
    this.rootontap,
    this.stackontap,
    required this.startDate,
    required this.endDate,
    required this.apiResponseList,
    required this.customCardWidget,
    required this.onStartDateSelected, // Added callback for start date
    required this.onEndDateSelected, // Added callback for end date
  }) : super(key: key);

  @override
  _MasterViewState createState() => _MasterViewState();
}

class _MasterViewState extends State<MasterView> {
  var sortedApiResponseList;
  var sortedApiResponseListWithoutZeros;
  final formatter = NumberFormat('#,###');
  String? totalsale;
  int totals = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      totals = 0;
      for (int i = 0; i < widget.apiResponseList.length; i++) {
        double salesValue = widget.apiResponseList[i]['Sales_Inc_ST'] ?? 0;
        totals += salesValue.round();
      }
      totalsale = formatter.format(totals);
    });
    sortedApiResponseList = List.from(widget.apiResponseList);
    sortedApiResponseListWithoutZeros = List.from(widget.apiResponseList);
    sortData();
  }

  void sortData() {
    sortedApiResponseList.sort((a, b) {
      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      double aSales = double.tryParse(aSalesStr) ?? 0;
      double bSales = double.tryParse(bSalesStr) ?? 0;
      return bSales.compareTo(aSales);
    });

    for (var data in sortedApiResponseList) {
      var formattedSales = formatter.format(double.tryParse(data['Sales_Inc_ST']?.toString() ?? '0') ?? 0);
      data['Sales_Inc_ST'] = formattedSales; // Replace original sales value with formatted value
    }

    sortedApiResponseListWithoutZeros = sortedApiResponseList.where((item) {
      String salesStr = item['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      double sales = double.tryParse(salesStr) ?? 0;
      return sales > 0;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [

              if(widget.totalsaleswithchart == false)
              InkWell(
                onTap: widget.totalsaleTap,

                child: TotalSalesCard(
                  totalSale: totalsale.toString(),
                  title: widget.title,
                ),
              ),
              if(widget.totalsaleswithchart == true)
                InkWell(
                  onTap: widget.totalsaleTap,

                  child: TotalSalesCardwithpie(
                    totalSale: totalsale.toString(),
                    title: widget.title,
                  ),
                ),



              if(widget.rootlist !=null)
              SizedBox(height: 50,),
              if(widget.rootlist !=null)
              Container(
                height:40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: widget.rootontap,
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
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: widget.rootlist!.asMap().map((index, stackItem) {


                              if (index == widget.rootlist!.length - 1) {

                              }


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
                                          color: index == widget.rootlist!.length - 1
                                              ? AppColors.primary
                                              : Colors.white,


                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: GestureDetector(

                                          onTap: () {
                                            if (widget.stackontap != null) {
                                              widget.stackontap!(index);
                                            }
                                          },

                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child:
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text(
                                                  widget.rootlist![index]['category'],
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: index == widget.rootlist!.length - 1
                                                        ? FontWeight.w600 : FontWeight
                                                        .normal,

                                                    color: index == widget.rootlist!.length - 1
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 3,),
                                                Text( widget.rootlist![index]['name'], style:
                                                TextStyle(
                                                  fontSize: 11,
                                                   color: index == widget.rootlist!.length - 1
                                                    ? Colors.white
                                                    : Colors.black,),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                                .values
                                .toList().reversed.toList(),


                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if(widget.rootlist !=null)
              SizedBox(height: 20,),
              if(widget.rootlist ==null)
                SizedBox(height: 40,),
              Expanded(
                child: widget.apiResponseList.isNotEmpty
                    ? widget.sortdata == "With Zero"
                    ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sortedApiResponseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = sortedApiResponseList[index];
                    return widget.customCardWidget(data); // Using the custom card widget passed in
                  },
                )
                    : widget.sortdata == "Without Zero"
                    ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sortedApiResponseListWithoutZeros.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = sortedApiResponseListWithoutZeros[index];
                    return widget.customCardWidget(data); // Using the custom card widget passed in
                  },
                )
                    : Container() // Handle the case when `sortdata` is neither "with zeros" nor "without zeros"
                    : Container(
                  height: 400,
                  child: Nodata(), // Handle no data state
                ),
              ),
            ],
          ),
          Positioned(
            top: widget.totalsaleswithchart == false ?130 : 290,
            right: 0,
            left: 0,
            child: DateRangeSelector(
              startDate: widget.startDate,
              endDate: widget.endDate,
              showDateContainers: true,
              onStartDateSelected: widget.onStartDateSelected, // Pass the callback for start date
              onEndDateSelected: widget.onEndDateSelected, // Pass the callback for end date
            ),
          ),
        ],
      ),
    );
  }
}

class DateContainer extends StatefulWidget {
  final String title;
  final String range;
  Color? color;
  Color? textcolor;
  Color? titlecolor;
  final Function(DateTime) onDateSelected;
  DateTime? selectedDate;
  bool isVisible;

  DateContainer({
    Key? key,
    required this.title,
    this.color =Colors.white,
    this.textcolor = AppColors.greencolor ,
    this.titlecolor =Colors.black,
    required this.range,
    required this.isVisible,
    required this.onDateSelected,
    this.selectedDate,
  }) : super(key: key);

  @override
  _DateContainerState createState() => _DateContainerState();
}

class _DateContainerState extends State<DateContainer> {


  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: widget.selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: AppColors.greencolor, // Set your desired color here
                  accentColor: Colors.green,
                  colorScheme: ColorScheme.light(primary: AppColors.greencolor ?? Colors.green),
                  buttonTheme: ButtonThemeData(
                      textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
          );

          if (picked != null && picked != widget.selectedDate) {
            setState(() {
              widget.selectedDate = picked;
              widget.onDateSelected?.call(picked);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [


              Container(

                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black38,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: widget.titlecolor,
                            fontSize: 12
                            , fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        widget.selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
                            : widget.range,
                        style: TextStyle(color: widget.textcolor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Exit {


static Future<bool> showExitDialog(BuildContext context) async {


    return showDialog<bool>(
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
              color: AppColors.greencolor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Exit App',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Are you sure you want to exit?',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white
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
                      onPressed: ()  {
                        exit(0);
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
    ).then((value) => value ?? false);
  }

  //
  //
  //
  // static Future<bool> showExitDialog(BuildContext context) async {
  //   return showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false, // user must tap on a button
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Exit App'),
  //         content: Text('Are you sure you want to exit?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               // Close the dialog and do not exit
  //               Navigator.of(context).pop(false);
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Close the dialog and exit the app
  //               Navigator.of(context).pop(true);
  //             },
  //             child: Text('Exit'),
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((value) => value ?? false);
  // }
}


class SalesHelper {

  static String calculateTotalSales(var apiResponseList) {
    double totals = 0;

    // Summing up the sales values from the apiResponseList
    for (int i = 0; i < apiResponseList.length; i++) {
      double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
      totals += salesValue.round();
    }

    var formatter = NumberFormat('#,###');
    String formattedTotalSales = formatter.format(totals);

    return formattedTotalSales;
  }
}
