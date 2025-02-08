import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/get_bracnhes_model.dart';
import '../../../model/get_channels_model.dart';
import '../../../respository/get_branches_repositiory.dart';
import '../../../respository/get_channel_repository.dart';
import '../../../respository/team_company.dart';
import '../../../utils/customs_widgets/circle_avatar_index.dart';


class Pspl_view_model extends ChangeNotifier
{
  bool isLoading=false;
  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate = DateTime.now();
  var datalist;

  List<int> branchnumbers=[];

  int total=0;

  String formattedTotalbranch='';
  String formattedTotalchannel='';
  final formatter = NumberFormat('#,###');
  String startDateFormatted = '';
  String endDateFormatted = '';
  List<String> items = ["Category", "SubCategory", "Brand", "Product"];
  List<Map<String, dynamic>> selecteditem = [];
  List<String> selectedmeasures=[];
  String companycode= '';
  String categorycode='';
  String subcategorycode='';
  String brandcode='';
  int totalbranch=0;
  String  productcode='';
  String classname='Company';
  bool sortwithzero =false;
  List<get_bracnhes_model> branches = [];
  List<get_channels_model> channel = [];
  void initializeDates(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    notifyListeners(); // Notify listeners in case the dates are updated
  }
  void addItemToSelected(String item, String name) {
    selecteditem.add(
        {
          "category": item,
          "name": name
        }
    );
    classname = item;
    print("selecteditem ${selecteditem}");
    print(items);
    notifyListeners();
  }
  clearcodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    await prefs.remove('companycode');
    await prefs.remove('categorycode');
    await prefs.remove('subcategorycode');
    await prefs.remove('productcode');
    await prefs.remove('brandcode');

    print("Specific values removed from SharedPreferences!");
  }
  Future<void> getcodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    companycode = prefs.getString('companycode') ?? ''; // default to empty string if null
    categorycode = prefs.getString('categorycode') ?? ''; // default to empty string if null
    subcategorycode = prefs.getString('subcategorycode') ?? ''; // default to empty string if null
    productcode = prefs.getString('productcode') ?? ''; // default to empty string if null
    brandcode = prefs.getString('brandcode') ?? ''; // default to empty string if null

    // Print the retrieved values
    print('Retrieved from SharedPreferences:');
    print('Company Code: $companycode');
    print('Category Code: $categorycode');
    print('SubCategory Code: $subcategorycode');
    print('Product Code: $productcode');
    print('Brand Code: $brandcode');
  }
  savecodes(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Initialize variables as Strings
    String? Company;
    String? Category;
    String? Subcategory;
    String? Brand;
    String? Product;

    // Assign the values from the 'data' map to the variables if they are not null
    if (data['Product_Company_Code'] != null) {
      Company = data['Product_Company_Code'].toString(); // Convert to String
      await prefs.setString('companycode', Company);
      print("Company Code saved: $Company");
    }

    if (data['Product_Category_Code'] != null) {
      Category = data['Product_Category_Code'].toString(); // Convert to String
      await prefs.setString('categorycode', Category);
      print("Category Code saved: $Category");
    }

    if (data['Product_SubCategory_Code'] != null) {
      Subcategory = data['Product_SubCategory_Code'].toString(); // Convert to String
      await prefs.setString('subcategorycode', Subcategory);
      print("SubCategory Code saved: $Subcategory");
    }

    if (data['Product_Brand_Code'] != null) {
      Brand = data['Product_Brand_Code'].toString(); // Convert to String
      await prefs.setString('brandcode', Brand);
      print("Brand Code saved: $Brand");
    }

    if (data['Product_Product_Code'] != null) {
      Product = data['Product_Product_Code'].toString(); // Convert to String
      await prefs.setString('productcode', Product);
      print("Product Code saved: $Product");
    }

    // Notify listeners after saving the data
    notifyListeners();
  }
  void clear(){
    selecteditem.clear();
    categorycode ='';
    subcategorycode ='';
    brandcode='';
    productcode='';
    companycode='';
    classname="Company";
    items = ["Category", "SubCategory", "Brand", "Product"];
   notifyListeners();
  }
  Future<void> getdata( String columnname, List<String> classname,) async {
    isLoading = true;
     notifyListeners();

    try {

      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);

      final result = await team_company_Repository().masterapi(
          startDateFormatted,
          endDateFormatted,
          columnname,
          classname,
        companycode.isNotEmpty ? [companycode] : [],  // pass empty list if companycode is empty
        categorycode.isNotEmpty ? [categorycode] : [],  // same for other variables
        subcategorycode.isNotEmpty ? [subcategorycode] : [],
        brandcode.isNotEmpty ? [brandcode] : [],
        productcode.isNotEmpty ? [productcode] : [],
          selectedmeasures,
      );

      print('API Result: $result');
      datalist = result;
        isLoading=false;
        notifyListeners();
    }
    catch (e) {
        isLoading = false;
        notifyListeners();
      print('Error: $e');
    }

    finally {
        isLoading = false;
        notifyListeners();
    }
  }
  Future<void> getbracnhes(int companycodes) async {


    try {

      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      final result = await get_branches_Repository().fetchData(
        startDateFormatted,
        endDateFormatted,
        [companycodes],
      );
      print('API Result: $result');
      branches = result;
      isLoading=false;
      notifyListeners();

      ;
    } catch (e, stack) {
      print("stack: ${stack}");
      isLoading=false;
      notifyListeners();
      print('Error: $e');
    }
  }
  Future<void> getchannel(int companycodes) async {


      try {
        isLoading=false;
        notifyListeners();
        String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
        String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
        final result = await get_channel_Repository().fetchData(
          startDateFormatted,
          endDateFormatted,
          [companycodes],
        );
        print('API Result: $result');
          channel = result;
        isLoading=false;
        notifyListeners();

       ;
      } catch (e, stack) {
        print("stack: ${stack}");
        isLoading=false;
        notifyListeners();
        print('Error: $e');
      }
  }
  void category(BuildContext context, Function(String) onSelectCategory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white.withOpacity(0.95), // Slight transparency
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.28, // Adjusted height for compactness
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dialog Header
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 12.0), // Reduced spacing between header and list
                    child: Text(
                      'Select a Category',
                      style: TextStyle(
                        color: AppColors.greencolor,
                        fontSize: 18, // Smaller text for header
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Divider for visual separation
                  // Divider(
                  //   thickness: 1,
                  //   color: AppColors.greencolor.withOpacity(0.2),
                  // ),

                  // List of Categories
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical space between items
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onSelectCategory(items[index]);

                            // Remove selected item and the ones before it
                            items.removeRange(0, index + 1);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black12,
                              //     blurRadius: 4,
                              //     offset: Offset(0, 2),
                              //   ),
                              // ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category,
                                    color: AppColors.greencolor,
                                    size: 22, // Adjusted icon size for better balance
                                  ),
                                  SizedBox(width: 10), // Slightly more space between icon and text
                                  Expanded(  // Ensures text takes all available space
                                    child: Text(
                                      items[index],
                                      style: TextStyle(
                                        color: AppColors.greencolor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14, // Smaller font size for a cleaner look
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 16),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), // Smaller padding for the button
                    decoration: BoxDecoration(
                      color: AppColors.greencolor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 12, // Smaller text size for button
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void showCompanyDetailsDialog(
      BuildContext context,
      List<get_bracnhes_model> team, String companyid, String branch, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text('Branches', style: TextStyle(color: Colors.white))),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 10),
            width: double.maxFinite,
            child: Column(
              children: [
                Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold,  color: AppColors.primary, fontSize: 15))),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: team.length,
                    itemBuilder: (BuildContext context, int index) {

                      team.sort((a, b) => int.parse(b.Sales.replaceAll(',', '')) - int.parse(a.Sales.replaceAll(',', '')));

                      get_bracnhes_model item = team[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Circle_avater(index: index + 1),
                                // Adjust the size as needed
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.Branch ?? ''}',
                                      style: TextStyle(fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,),
                                    ),
                                    Text('Sale: ${item.Sales ?? ''}',
                                      style: TextStyle(
                                        fontSize: 14,  color: AppColors.primary,),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            Divider(color:  AppColors.primary,),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          // Adjust the horizontal padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // Adjust the border radius as needed
            side: BorderSide(width: 2,
                color: Colors.transparent), // Set the border width and color
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary,
              ),

              child: Text('Total Sales: ${branch.toString()}', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',
                  style: TextStyle(fontSize: 16,  color: AppColors.primary,)),
            ),
          ],
        );
      },
    );
  }

  void showchannelDetailsDialog(BuildContext context, List<get_channels_model> team, String companyid, String total, String name) {
    // Initialize totalSales variable to store the sum of sales

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:  AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('Channels', style: TextStyle(color: Colors.white)),
            ),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 10),
            width: double.maxFinite,
            child: Column(
              children: [
                Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold,  color: AppColors.primary, fontSize: 13))),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: team.length,
                    itemBuilder: (BuildContext context, int index) {
                      team.sort((a, b) => int.parse(b.Sales.replaceAll(',', '')) - int.parse(a.Sales.replaceAll(',', '')));

                      get_channels_model item = team[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Circle_avater(index: index + 1),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.Class ?? ''}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'Sale: ${item.Sales ?? ''}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primary,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            Divider(color: AppColors.primary,),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(width: 2, color: Colors.transparent),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary,
              ),
              child: Text('Total Sales: ${total.toString()}', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


}