import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/utils/customs_widgets/Custom_app_bar.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:share/share.dart';
import '../../../respository/product_repository.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';

enum SortOptions { Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale }
class Company_Product extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String companyid;
  final String name;
final String company_name;
  final List<int> companylist;
  final List<int> branchlist;
  late List<String> selectedmeasures;

   Company_Product({
    required this.empCode,
    required this.startDate,
    required this.endDate,
    required this.companyid,
    required this.name,
    required this.company_name,
    required this.companylist,
    required this.branchlist,
     required this.selectedmeasures,

    Key? key,
  }) : super(key: key);

  @override
  State<Company_Product> createState() => _CustomerWiseState();
}

class _CustomerWiseState extends State<Company_Product> {

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
  bool sortwithzero =false;
  bool isloading = false;
  DateTime? startDate;
  DateTime? endDate;
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
      product_Repository().product_fetchData(
      widget.empCode,
      widget.companyid,
          startDateFormatted.toString(),
          endDateFormatted.toString(),
        [widget.companyid.toString()],
        widget.branchlist,
        widget.selectedmeasures
    );
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
            ], onSelected: (value) {


            if (value == 'share')
            {
              String combinedMessage = '';

              combinedMessage += "Start Date: $startDateFormatted\nEnd Date: $endDateFormatted\n\n";

              for (int i = 0; i < customerDataFuture.length; i++) {
                if (
                customerDataFuture[i]['Product_Company_ID'].toString().isNotEmpty) {
                  String name = customerDataFuture[i]['Product_Product_Name'];


                  String sale = NumberFormat('#,###').format(double.parse(customerDataFuture[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));
                  sale = sale.isEmpty ? '0' : sale;

                  String measure = ''; // Reset measure for each iteration



                  combinedMessage += "Name: $name\nSale: $sale\n\n";
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
                TotalSalesCard(totalSale: totalsale.toString(), title: 'Comapany Product Wise Sales',),
                SizedBox(height: 40,),
                SalesListView(
                  sortdata: sortwithzero == false ? 'With Zero' : 'Without Zero',
                  apiResponseList: customerDataFuture,

                  customCardWidget:(data) {
                    return
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: HeirarchyCard(
                          title: data['Product_Product_Name'].toString(),
                          date: "",
                          amount: data['Sales_Inc_ST'].toString(),
                          color: AppColors.greencolor,
                          designation: "",
                          onTap: () async {

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
// import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
// import '../../model/product_model.dart';
// import '../../respository/product_repository.dart';
// import '../../utils/customs_widgets/list_filters.dart';

// import '../../utils/datefixed_containers.dart';
//
// enum SortOptions { Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale }
// class Company_Product extends StatefulWidget {
//   final String empCode;
//   final String startDate;
//   final String endDate;
//   final String companyid;
//   final String name;
// final String company_name;
//   final List<int> companylist;
//   final List<int> branchlist;
//   late List<String> selectedmeasures;
//
//    Company_Product({
//     required this.empCode,
//     required this.startDate,
//     required this.endDate,
//     required this.companyid,
//     required this.name,
//     required this.company_name,
//     required this.companylist,
//     required this.branchlist,
//      required this.selectedmeasures,
//
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<Company_Product> createState() => _CustomerWiseState();
// }
//
// class _CustomerWiseState extends State<Company_Product> {
//   var customerDataFuture;
//
//   String total='0';
//   double totalSales=0;
//   bool calender=false;
//   bool ischeck=false;
//   var originalStoredata;
//   SortOptions selectedSortOption = SortOptions.Select;
//   void _sortData(bool ascending) {
//     // First, filter out items with empty customerName
//     List<Compnay_ProductModel> nonEmptyCustomerNameData = storedate
//         .where((data) => data.sku.isNotEmpty)
//         .toList();
//
//     // Sort the filtered list based on sales
//     nonEmptyCustomerNameData.sort((a, b) {
//       if ((a.sales == null || a.sales ==0) &&
//           (b.sales == null || b.sales==0)) {
//         return 0;
//       } else if (a.sales == null || a.sales ==0) {
//         return ascending ? -1 : 1;
//       } else if (b.sales == null || b.sales ==0) {
//         return ascending ? 1 : -1;
//       }
//
//       try {
//         double aSales = double.parse(a.sales.toString().replaceAll(',', '') ?? '0.0');
//         double bSales = double.parse(b.sales.toString().replaceAll(',', '') ?? '0.0');
//
//
//         return ascending ? aSales.compareTo(bSales) : bSales.compareTo(aSales);
//       } catch (e) {
//         print('Error parsing double: $e');
//         return 0;
//       }
//     });
//
//     // Now, update the original storedate list with the sorted data
//     for (int i = 0; i < storedate.length; i++) {
//       if (storedate[i].sku.isNotEmpty) {
//         storedate[i] = nonEmptyCustomerNameData.removeAt(0);
//       }
//     }
//   }
//
//   void select(BuildContext context) {
//     SortOptions? selected = SortOptions.Select;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.green[800],
//           title: Text(
//             'Sort Options',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Container(
//             decoration: BoxDecoration(
//               color: Colors.green[800],
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             child: DropdownButton<SortOptions>(
//               value: selectedSortOption,
//               onChanged: (SortOptions? newValue) {
//                 if (newValue != null) {
//                   setState(() {
//                     selectedSortOption = newValue;
//                     Navigator.of(context).pop();
//                     sortCustomers();
//                   });
//                 } else {
//                   setState(() {
//                     storedate = List.of(originalStoredata);
//                   });
//                 }
//               },
//               items: [
//                 buildDropdownItem(
//                   SortOptions.Select,
//                   'Select Sort',
//                 ),
//                 buildDropdownItem(
//                   SortOptions.byAscendingName,
//                   'Sort by Name in Ascending order',
//                 ),
//                 buildDropdownItem(
//                   SortOptions.byDecendingName,
//                   'Sort by Name in Descending order',
//                 ),
//                 buildDropdownItem(
//                   SortOptions.byMaximumSale,
//                   'Sort by Maximum to Minimum Sale',
//                 ),
//                 buildDropdownItem(
//                   SortOptions.byMinimumSale,
//                   'Sort by Minimum to Maximum Sale',
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   DropdownMenuItem<SortOptions> buildDropdownItem(SortOptions value,
//       String label,) {
//     return DropdownMenuItem(
//       value: value,
//       child: Container(
//         padding: EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: Colors.green[800],
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(fontSize: 12, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   void _sortDescendingName() {
//     storedate.sort((a, b) {
//       if (a.sku.isEmpty && b.sku.isEmpty) {
//         return 0;
//       } else if (a.sku.isEmpty) {
//         return 1;
//       } else if (b.sku.isEmpty) {
//         return -1; // Move items with empty SKU to the end
//       } else {
//         return b.sku.compareTo(a.sku);
//       }
//     });
//   }
//
//   void sortCustomers() {
//     switch (selectedSortOption) {
//       case SortOptions.byAscendingName:
//         storedate.sort((a, b) {
//           if (a.sku.isEmpty && b.sku.isEmpty) {
//             return 0;
//           } else if (a.sku.isEmpty) {
//             return 1; // Move items with empty SKU to the end
//           } else if (b.sku.isEmpty) {
//             return -1; // Move items with empty SKU to the end
//           } else {
//             return a.sku.compareTo(b.sku);
//           }
//         });
//         break;
//       case SortOptions.byDecendingName:
//         _sortDescendingName();
//         break;
//       case SortOptions.byMaximumSale:
//         _sortData(false);
//         break;
//       case SortOptions.byMinimumSale:
//         _sortData(true);
//         break;
//       default:
//         break;
//     }
//     print("Sorted data: $storedate");
//   }
//
//
//  var storedate;
//   @override
//   void initState() {
//     super.initState();
//     customerDataFuture = product_Repository().product_fetchData(
//       widget.empCode,
//       widget.companyid,
//       widget.startDate,
//       widget.endDate,
//         [widget.companyid.toString()],
//         widget.branchlist,
//         widget.selectedmeasures
//     );
//     customerDataFuture.then((data) {
//       setState(() {
//         storedate = data;
//         for(int i=0; i<data.length;i++){
//           totalSales+=data[i]['Sales_Inc_ST']!;
//
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.company_name),
//         backgroundColor: Colors.green[800],
//         actions:[
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) {
//               return [
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
//               if (value == 'Sort') {
//                 // Combine the information into a single text message
//                 String combinedMessage = ''; // Initialize the combined message outside the loop
//                 setState(() {
//                   select(context);
//                 });
//
//               }
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
//         ],
//       ),
//       body: Column(
//         children: [
//
//           //heading_container(title: widget.name, gradientColor: Colors.green[800],),
//           Container(
//
//             decoration: BoxDecoration( color: Colors.green.shade100,
//               borderRadius: BorderRadius.only( bottomLeft: Radius.circular(15),
//                 bottomRight: Radius.circular(15),),
//               // border: Border.all(
//               //   color: Colors.green[800]??Colors.green, // Border color
//               //   width: 1.0, // Border width
//               // ),
//
//               // gradient:
//               // LinearGradient(
//               //   begin: Alignment.topLeft,
//               //   end: Alignment.bottomRight,
//               //   colors: [
//               //     Colors.green[800]!,  // Darker shade of green
//               //     Colors.green  // Lighter shade of green
//               //   ],
//               // ),
//               // boxShadow: [
//               //   BoxShadow(
//               //     color: Colors.green.withOpacity(0.2), // Shadow color
//               //     spreadRadius: 5, // Spread radius
//               //     blurRadius: 10, // Blur radius
//               //     offset: Offset(0, 3), // Shadow offset
//               //   ),
//               // ],
//             ),
//             child:   Padding(
//               padding: const EdgeInsets.all(10.0),
//               child:   Row(
//
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                 children: [
//                   SizedBox(width: 10,),
//                   Expanded(flex:4,child: Text(widget.name,style: TextStyle(color: Colors.green[800], fontSize: 13, fontWeight: FontWeight.bold ),),),
//                   //SizedBox(width: 20,),
//                   Expanded(flex:2, child:  Container(
//                       child: Text(textAlign: TextAlign.right,"Sales", style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),)),),
//                   Expanded(flex:2, child:Text(textAlign: TextAlign.right,"Execution",  style: TextStyle(color: Colors.green[800], fontSize: 15, fontWeight: FontWeight.bold ),)),
//                 ],),
//
//             ),
//           ),
//           Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children:[
//                 Expanded(child: datefixedcontainer(title: widget.startDate, isvisible: calender, name: 'Start Date',)),
//                 Expanded(child: datefixedcontainer(title: widget.endDate, isvisible: calender, name: 'End Date',)),
//                 // Expanded(
//                 //   child: DateContainer(title: "Start Date", range: widget.startDate, isVisible: calender,  onDateSelected: (date) {
//                 //     setState(() {
//                 //       widget.startDate;
//                 //     });
//                 //   },),
//                 // ),
//                 // Expanded(
//                 //   child:DateContainer(title: "Start Date", range: widget.endDate, isVisible: calender,  onDateSelected: (date) {
//                 //     setState(() {
//                 //       widget.endDate;
//                 //     });
//                 //   },),),
//
//               ]),
//           Expanded(child: FutureBuilder<List>(
//             future: customerDataFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return _buildLoadingWidget();
//               } else if (snapshot.hasError) {
//                 return _buildErrorWidget(snapshot.error.toString());
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return _buildNoDataWidget();
//               } else {
//                 return _buildListView(snapshot.data!);
//               }
//             },
//           ),),
//           calculated_sale(totalsale: NumberFormat('#,###').format(totalSales.round())
//
//           )],
//       ),
//     );
//   }
//
//   Widget _buildLoadingWidget() {
//     return Center(
//       child: CircularProgressIndicator(color: Colors.green),
//     );
//   }
//
//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Text('Error: $error'),
//     );
//   }
//
//   Widget _buildNoDataWidget() {
//     return Center(
//       child: Text(
//         'No data available',
//         style: TextStyle(color: Colors.green[800]),
//       ),
//     );
//   }
//
//   Widget _buildListView(List data) {
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       physics: BouncingScrollPhysics(),
//       itemCount: data.length,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//
//         data.sort((a, b) {
//           String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
//           String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
//
//           double aSales = double.tryParse(aSalesStr) ?? 0;
//           double bSales = double.tryParse(bSalesStr) ?? 0;
//
//           return bSales.compareTo(aSales);
//         });
//
//         final customerData = data[index];
//
//     return Column(
//     children: [
//     if (customerData['Sales_Inc_ST']!=null && ischeck==false)
//
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ProductItem(  item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Product_Name',code:""),
//         ),
//
//       if (ischeck==true)
//
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ProductItem(   item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Product_Name',code:""),
//         ),
//
//     ],
//     );
//
//     });}}