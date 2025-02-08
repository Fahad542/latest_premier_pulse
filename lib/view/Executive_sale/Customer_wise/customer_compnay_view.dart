import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../respository/customer_company_repositiry.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import '../../../utils/utils.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/utils/customs_widgets/Custom_app_bar.dart';
import 'package:share/share.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import 'customer_product.dart';

enum SortOptions { Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale }

class CustomerCompanyWise extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String customerid;
final String customername;
final String customerwisename;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;
   CustomerCompanyWise({
    required this.empCode,
    required this.startDate,
    required this.endDate,
    required this.customerid,
    required this.companylist,
    required this.branchlist,
    required this.customername,
    required this.customerwisename,
    required this.selectedmeasures,
     Key? key,
  }) : super(key: key);

  @override
  State<CustomerCompanyWise> createState() => _CustomerWiseState();
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

class _CustomerWiseState extends State<CustomerCompanyWise> {

  String sale = '';
  SortOptions selectedSortOption = SortOptions.Select;
  var  originalStoredata ;

  // void select(BuildContext context) {
  //   SortOptions? selected = SortOptions.Select;
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.green[800],
  //         title: Text(
  //           'Sort Options',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.green[800],
  //             borderRadius: BorderRadius.circular(16.0),
  //           ),
  //           child: DropdownButton<SortOptions>(
  //             value: selectedSortOption,
  //             onChanged: (SortOptions? newValue) {
  //               if (newValue != null) {
  //                 setState(() {
  //                   selectedSortOption = newValue;
  //                   Navigator.of(context).pop();
  //                   // sortCustomers();
  //                 });
  //               } else {
  //                 setState(() {
  //                   storedata = List.of(originalStoredata);
  //                 });
  //               }
  //             },
  //             items: [
  //               buildDropdownItem(
  //                 SortOptions.Select,
  //                 'Select Sort',
  //               ),
  //               buildDropdownItem(
  //                 SortOptions.byAscendingName,
  //                 'Sort by Name in Ascending order',
  //               ),
  //               buildDropdownItem(
  //                 SortOptions.byDecendingName,
  //                 'Sort by Name in Descending order',
  //               ),
  //               buildDropdownItem(
  //                 SortOptions.byMaximumSale,
  //                 'Sort by Minimum to Maximum Sale',
  //               ),
  //               buildDropdownItem(
  //                 SortOptions.byMinimumSale,
  //                 'Sort by Maximum to Minimum Sale',
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  var customerDataFuture;
  var storedata;
  var store;
  String total='0';
  bool isloading = false;
  DateTime? startDate;
  DateTime? endDate;
  String? startDateFormatted;
  String? endDateFormatted;
  String? totalsale;
  bool sortwithzero=false;
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

      List<String> parts = dateStr.split(',');
      if (parts.length == 3) {
        String formattedDate = "${parts[0]}-${parts[1]}-${parts[2]}";
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
      customerDataFuture = await customer_company_Repository().customer_company_fetchData(
      widget.empCode.toString(),
      widget.customerid.toString(),
          startDateFormatted!,
          endDateFormatted!,
      widget.companylist,
      widget.branchlist,widget.selectedmeasures
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
      appBar: CustomAppBar(title: widget.customername,

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
                TotalSalesCard(totalSale: totalsale.toString(), title: 'Customer Comapany Wise Sales',),
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
                          designation: "",
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerProductWise(
                                      customerid: widget.customerid,
                                      customername: data['Product_Company_Name'].toString(),
                                      empCode: widget.empCode,
                                      startDate: DateFormat('yyyy,MM,dd').format(startDate!),
                                      endDate: DateFormat('yyyy,MM,dd').format(endDate!),
                                      companylist: widget.companylist,
                                      branchlist: widget.branchlist,
                                      customerwisename: widget.customerwisename,
                                      selectedmeasures: widget.selectedmeasures,
                                      productid: data['Product_Company_ID'].toString(),
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
                      print("Start Date selected: $startDate");
                      if (startDate!.isAfter(endDate!))
                      {
                        Utils.toastMessage("Start date cannot be after the end date");
                      }
                      else
                      {
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
  }
}



