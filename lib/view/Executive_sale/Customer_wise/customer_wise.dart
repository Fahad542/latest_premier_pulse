import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/respository/customer_wise_repository.dart';
import 'package:mvvm/utils/customs_widgets/Custom_app_bar.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:share/share.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import 'customer_compnay_view.dart';


enum SortOptions {

  Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale

}
class customer_wise extends StatefulWidget {

  final String empCode;
  final String startDate;
  final String endDate;
  final String name;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;
  customer_wise(String emp_code, String startdate, String enddate, {Key? key, required this.empCode, required this.startDate, required this.endDate, required this.name, required this.companylist, required this.branchlist, required this.selectedmeasures}) : super(key: key);
  @override
  State<customer_wise> createState() => _customer_wiseState();

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


  var storedata;

class _customer_wiseState extends State<customer_wise> {

  String sale = '';
  SortOptions selectedSortOption = SortOptions.Select;
 var originalStoredata ;

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

   var customerDataFuture;
  var storedata;
  var store;
  String total='0';
  bool isloading = false;
  DateTime? startDate;
  DateTime? endDate;
  String? startDateFormatted;
  String? endDateFormatted;
  bool sortwithzero =false;
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
      customerDataFuture = await customerRepository().customer_wise_fetchData(
          widget.empCode,
          startDateFormatted!,
          endDateFormatted!,
          widget.companylist,widget.branchlist,widget.selectedmeasures
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
                  customerDataFuture[i]['Customer_Cust_Name'].isNotEmpty) {
                    String name = customerDataFuture[i]['Customer_Cust_Name'];
                    String id = customerDataFuture[i]['Customer_BRCUST'].toString();

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
             TotalSalesCard(totalSale: totalsale.toString(), title: 'Customer Wise Sales',),
              SizedBox(height: 40,),
              SalesListView(
                sortdata: sortwithzero == false ? 'With Zero' : 'Without Zero',
                apiResponseList: customerDataFuture,

                customCardWidget:(data) {
                  return
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: HeirarchyCard(
                        check: true,
                        title: data['Customer_Cust_Name'].toString(),
                        date: data['Customer_BRCUST'].toString(),
                        amount: data['Sales_Inc_ST'].toString(),
                        phone: data['Customer_Cust_Phone'],
                        lat: data['Customer_Cust_Latt'].toString(),
                        long: data['Customer_Cust_Long'].toString(),
                        color: AppColors.greencolor,
                        designation: "",
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerCompanyWise(
                                    customerid: data['Customer_BRCUST'].toString(),
                                    customername: data['Customer_Cust_Name'].toString(),
                                    empCode: widget.empCode,
                                    startDate: DateFormat('yyyy,MM,dd').format(startDate!),  // Pass updated startDate
                                    endDate: DateFormat('yyyy,MM,dd').format(endDate!),
                                    companylist: [],
                                    branchlist: [],
                                    customerwisename: '',
                                    selectedmeasures: [],
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
                startDate: startDate,
                endDate: endDate,
                showDateContainers: true,
                onStartDateSelected: (date) {
                  setState(() {
                    startDate = date;

                    print("Start Date selected: $startDate");


                    if (startDate!.isAfter(endDate!)) {

                      Utils.toastMessage("Start date cannot be after the end date");
                    } else {

                      getsales();
                    }
                  });
                },
                onEndDateSelected: (date) {
                setState(() {
                  endDate = date;

                  print("End Date selected: $endDate");


                  if (endDate!.isBefore(startDate!)) {

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
