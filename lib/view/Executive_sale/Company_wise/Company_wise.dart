import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/utils/customs_widgets/Custom_app_bar.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:share/share.dart';
import '../../../respository/company_wise.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import 'company_product.dart';

enum SortOptions {

  Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale

}

class company_wise extends StatefulWidget {

  final String empCode;
  final String startDate;
  final String endDate;
  final String name;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;

   company_wise(

      {Key? key,
        required this.empCode,
        required this.startDate,
        required this.endDate,
        required this.name,
        required this.companylist,
        required this.branchlist,
        required this.selectedmeasures
       }

       ) :
        super(key: key);

  @override
  State<company_wise> createState() => _customer_wiseState();
}

class _customer_wiseState extends State<company_wise> {



  void select(BuildContext context) {
    SortOptions? selected = SortOptions.Select;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[800],
          title: Text(
            'Sort Options',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: DropdownButton<SortOptions>(
              value: selectedSortOption,
              onChanged: (SortOptions? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSortOption = newValue;
                    Navigator.of(context).pop();
                    // sortCustomers();
                  });
                } else {
                  setState(() {
                    storedata = List.of(originalStoredata);
                  });
                }
              },
              items: [
                buildDropdownItem(
                  SortOptions.Select,
                  'Select Sort',
                ),
                buildDropdownItem(
                  SortOptions.byAscendingName,
                  'Sort by Name in Ascending order',
                ),
                buildDropdownItem(
                  SortOptions.byDecendingName,
                  'Sort by Name in Descending order',
                ),
                buildDropdownItem(
                  SortOptions.byMaximumSale,
                  'Sort by Minimum to Maximum Sale',
                ),
                buildDropdownItem(
                  SortOptions.byMinimumSale,
                  'Sort by Maximum to Minimum Sale',
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  DropdownMenuItem<SortOptions> buildDropdownItem(
      SortOptions value,
      String label,
      ) {
    return DropdownMenuItem(
      value: value,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
  bool isAscending=false;
  bool calender=false;
  bool ischeck=false;
  DateTime? Start;
  double totalSales = 0.0;
  DateTime? End;
  List<String> measuresList=[];
  String formattedStartDate='';
  String formattedEndDate='';
  var storedata; // Initialize the list
  String sale = '';
  SortOptions selectedSortOption = SortOptions.Select;
  var  originalStoredata ;
  var customerDataFuture;
  var store;
  String total='0';
  bool isloading = false;
  DateTime? startDate;
  DateTime? endDate;
  bool sortwithzero=false;
  String? startDateFormatted;
  String? endDateFormatted;
  String? totalsale;
  int totals=0;
  final formatter = NumberFormat('#,###');
  @override
  void initState() {
    super.initState();
    totalSales=0;
    startDate = _parseDate(widget.startDate);
    endDate = _parseDate(widget.endDate);
    getsales();

    print("total: $total");

  }
  DateTime? _parseDate(String dateStr) {
    try {
      // Split the string by commas, and join the parts to create a valid date string
      List<String> parts = dateStr.split(',');
      if (parts.length == 3) {
        String formattedDate = "${parts[0]}-${parts[1]}-${parts[2]}"; // yyyy-MM-dd
        return DateTime.parse(formattedDate);
      }
      return null; // Invalid format
    } catch (e) {
      print("Invalid date format: $dateStr");
      return null;
    }
  }
  Future<void> getsales() async {
    setState(() {
      startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);

      isloading =true;
    });
    try {
      customerDataFuture = await
      companyRepository().company_wise_fetchData(
          widget.empCode,
          startDateFormatted!,
          endDateFormatted!,
          widget.companylist,
   widget.branchlist, widget.selectedmeasures);
      setState(() {
        totals = 0;
        for (int i = 0; i < customerDataFuture.length; i++) {
          double salesValue = customerDataFuture[i]['Sales_Inc_ST'] ?? 0;
          totals += salesValue.round();
        }
        totalsale = formatter.format(totals);
      });
      setState(() {
        isloading =false;
      });

    }
    catch(e, stackstarce) {
      Utils.toastMessage(e.toString());
      setState(() {

        customerDataFuture=[];
        isloading =false;
      });
      print(stackstarce);
      print(e.toString());
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: widget.name,

        actions: [
          Icon(Icons.abc, color: AppColors.greencolor,),

          MyPopupMenu(
            menuItems: [
              MenuItem(
                text: 'Share',
                icon: Icons.share,
                value: 'share',
                onTap: () {
                  print('Share selected');

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

            ], onSelected: (value) {


            if (value == 'share')
            {
              String combinedMessage = '';

              combinedMessage += "Start Date: $startDateFormatted\nEnd Date: $endDateFormatted\n\n";

              for (int i = 0; i < customerDataFuture.length; i++) {
                if (
                customerDataFuture[i]['Product_Company_ID'].toString().isNotEmpty) {
                  String name = customerDataFuture[i]['Product_Company_Name'];
                  String id = customerDataFuture[i]['Product_Company_ID'].toString();

                  String sale = NumberFormat('#,###').format(double.parse(customerDataFuture[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));
                  sale = sale.isEmpty ? '0' : sale;

                  String measure = ''; // Reset measure for each iteration



                  combinedMessage += "Name: $name\nID: $id\nSale: $sale\n\n";
                }
              }

              Share.share(combinedMessage, subject: 'Sales Information');
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

      body:
      isloading ?
      shimmer_effect( isLoading: isloading , selectedmeasures: widget.selectedmeasures,)

          :
      Stack(
          children:[

            Column(
              children: [
                TotalSalesCard(totalSale: totalsale.toString(), title: 'Comapany Wise Sales',),
                SizedBox(height: 40,),
                SalesListView(
                  sortdata: sortwithzero == false ? 'With Zero' : 'Without Zero',
                  apiResponseList: customerDataFuture,

                  customCardWidget:(data) {
                    return
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: HeirarchyCard(
                          title: data['Product_Company_Name'].toString(),
                          date: data['Product_Company_ID'].toString(),
                          amount: data['Sales_Inc_ST'].toString(),
                          color: AppColors.greencolor,
                          designation: '',
                          onTap: () async {
                            Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Company_Product(
                                                  empCode: widget.empCode,
                                                  companyid: data['Product_Company_ID'].toString(),
                                                  startDate: widget.startDate,
                                                  endDate: widget.endDate,
                                                  name: data['Product_Company_Name'].toString(),
                                                  company_name: widget.name,
                                                  companylist: widget.companylist,
                                                  branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
                                                ),
                                          ),
                                        );
                          },

                          showsale: true,
                          selectedmeasures: [],
                          item: data,
                          saleonTap: () {  },

                        ),
                      );


                  },
                ),

              ],
            ),
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
                        getsales();
                      }
                    });
                  }, onEndDateSelected: (date ) {
                  setState(() {
                    endDate = date;

                    print("End Date selected: $endDate");

                    // Check if the end date is valid
                    if (endDate!.isBefore(startDate!)) {
                      // Show an error message to the user using a Snackbar
                      Utils.toastMessage("End date cannot be before the start date");

                    } else {

                      getsales();
                    }
                  });
                },
                )

            ),
          ] ),

    );
  }}

























// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mvvm/model/Company_wise.dart';
// import 'package:mvvm/respository/company_wise.dart';


// import '../../utils/customs_widgets/list_filters.dart';

// import '../../utils/datefixed_containers.dart';
// import '../../utils/utils.dart';
// import 'company_product.dart';
//
// class company_wise extends StatefulWidget {
//   final String empCode;
//   final String startDate;
//   final String endDate;
//   final String name;
//   final List<int>  companylist;
//   final List<int>  branchlist;
//   late List<String> selectedmeasures;
//
//    company_wise(
//       {Key? key,
//         required this.empCode,
//         required this.startDate,
//         required this.endDate,
//         required this.name,
//         required this.companylist,
//         required this.branchlist,
//         required this.selectedmeasures
//        }) :
//         super(key: key);
//
//   @override
//   State<company_wise> createState() => _customer_wiseState();
// }
//
// class _customer_wiseState extends State<company_wise> {
//
//   var storedat;
//   int companyid=0;
// double totalSales=0;
//  bool ischeck=false;
//   var customerDataFuture;
//   String total='0';
//   bool calender=false;
//   void _sortData() {
//     storedat.sort((a, b) {
//       // Check for zero sales
//       if (a.sales == null || b.sales == null) return 0;
//
//       // Handle zero sales differently
//       if (a.sales == '0' || a.sales==0) {
//         return isAscending ? -1 : 1;
//       }
//
//       if (b.sales == '0' || b.sales==0) {
//         return isAscending ? 1 : -1;
//       }
//
//       try {
//         // Remove commas and parse as double
//         double aSales = double.parse(a.sales.toString().replaceAll(',', '') ?? '0.0');
//         double bSales = double.parse(b.sales.toString().replaceAll(',', '') ?? '0.0');
//         return isAscending ? aSales.compareTo(bSales) : bSales.compareTo(aSales);
//       } catch (e) {
//         // Handle the exception, you can print an error message or log it
//         print('Error parsing double: $e');
//         return 0;
//       }
//     });
//   }
//
//
//
//   @override
//   void initState() {
//     isAscending = false;
//     super.initState();
//     customerDataFuture = companyRepository().company_wise_fetchData(widget.empCode, widget.startDate, widget.endDate,widget.companylist,
//         widget.branchlist, widget.selectedmeasures);
//     customerDataFuture.then((data) {
//       setState(() {
//         storedat = data;
//         for(int i=0; i<data.length;i++){
//           totalSales+=data[i]['Sales_Inc_ST'];
//
//         }
//       });
//
//     });
//   }
//
//   bool isAscending = false;
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar:
//
//
//       AppBar(
//         title: Text(widget.name, style: TextStyle(),),
//         backgroundColor: Colors.green[800],
//         actions:[
//
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) {
//               return [
//
//                 PopupMenuItem(
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.green[800],
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Icon(Icons.calendar_today, color: Colors.white, size: 18),
//                       ),
//                       SizedBox(width: 6),
//                       Text(calender ? 'Dates off' : 'Dates', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                   value: 'date',
//                 ),
//
//                 PopupMenuItem(
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.green[800],
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Icon(Icons.format_list_numbered, color: Colors.white, size: 18),
//                       ),
//                       SizedBox(width: 6),
//                       Text(ischeck ? 'Without 0s' : 'With 0s', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                   value: 'sales',
//                 ),
//               ];
//             },
//             onSelected: (value) {
//               // Handle menu item selection here
//               if (value == 'Measures') {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return filters(
//                       onSelectionDone: (selectedValues) {
//                         setState(() {
//                           widget.selectedmeasures =selectedValues.toList();
//                         });
//                         // Use selectedValues her
//                       },
//                       selectedvalues: widget.selectedmeasures,
//                     );
//
//                   },
//                 );
//               }
//               if (value == 'date') {
//                 setState(() {
//
//                   calender = !calender;
//                 });
//               }
//
//               if (value == 'sales') {
//                 setState(() {
//                   ischeck = !ischeck;
//                 });
//               } else {
//                 print('Selected: $value');
//               }
//             },
//           ),
//
//
//         ],
//       ),
//       body:
//
//       Column(
//         children: [
//
//           Container(
//
//             decoration: BoxDecoration( color: Colors.green.shade100,
//               borderRadius: BorderRadius.only( bottomLeft: Radius.circular(15),
//                 bottomRight: Radius.circular(15),),
//
//             ),
//             child:   Padding(
//               padding: const EdgeInsets.all(10.0),
//               child:   Row(
//
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                 children: [
//                   SizedBox(width: 20,),
//                   Expanded(flex:6,child: Text("Company",style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),),),
//                   Expanded(flex:2, child:  Container(
//                       child: Text("Sales", style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),)),),
//                   //Expanded(flex:2, child:Text("Execution",  style: TextStyle(color: Colors.green[800], fontSize: 15, fontWeight: FontWeight.bold ),)),
//                 ],),
//
//             ),
//           ),
//           Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children:[
//                 Expanded(child: datefixedcontainer(title: widget.startDate, isvisible: calender, name: 'Start Date',)),
//                 Expanded(child: datefixedcontainer(title: widget.endDate, isvisible: calender, name: 'End Date',)),
//
//
//               ]),
//           Expanded(
//             child: FutureBuilder<List>(
//               future: customerDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(color: Colors.green,),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(''),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(
//                       child: Text('No data available',
//                         style: TextStyle(color: Colors.green[800],),
//                       ));
//                 } else {
//                   snapshot.data!.sort((a, b) => (b['Sales_Inc_ST'] ?? 0).compareTo(a['Sales_Inc_ST'] ?? 0));
//                   return ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       physics: BouncingScrollPhysics(),
//                       itemCount: snapshot.data!.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         final companyData = snapshot.data![index];
//                         if (companyData['Product_Company_Name']!= null ) {
//
//                         return
//                           Column(
//                             children: [
//                               if(companyData['Sales_Inc_ST']!=null && ischeck==false)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 10,left: 10),
//                                   child: InkWell(
//                                     onTap: (){
//
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Company_Product(
//                                                   empCode: widget.empCode,
//                                                   startDate: widget.startDate,
//                                                   endDate: widget.endDate,
//                                                   companyid: companyData['Product_Company_ID'].toString(),
//                                                   name: companyData['Product_Company_Name'].toString(),
//                                                   company_name: widget.name,
//                                                   companylist: widget.companylist,
//                                                   branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
//                                                 ),
//                                           ),
//                                         );
//
//                                     },
//                                     child:
//                                     ProductItem(   empcheck: true,item: companyData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",
//
//                                     ),
//
//
//                                   ),
//                                 ),
//
//                               if(ischeck==true)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 10,left: 10),
//                                   child: InkWell(
//                                     onTap: (){
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               Company_Product(
//                                                 empCode: widget.empCode,
//                                                 startDate: widget.startDate,
//                                                 endDate: widget.endDate,
//                                                 companyid: companyData['Product_Company_ID'].toString(),
//                                                 name: companyData['Product_Company_Name'].toString(),
//                                                 company_name: widget.name,
//                                                 companylist: [companyid],
//                                                 branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
//                                               ),
//                                         ),
//                                       );
//
//                                     },
//                                     child:
//                                     ProductItem(
//                                       empcheck: true,
//                                       item: companyData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",
//
//                                     ),
//
//
//                                   ),
//                                 ),
//                             ],
//                           );
//
//                        }
//                         print(snapshot.data![index]);
//
//                         }
//     );
//                 }
//               },
//             ),
//           ),
//          calculated_sale(totalsale: NumberFormat('#,###').format(totalSales.round())
//          )
//         ],
//       ),
//     );
//   }
// }
