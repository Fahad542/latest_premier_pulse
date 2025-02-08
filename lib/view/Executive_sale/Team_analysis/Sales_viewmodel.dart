import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/model/branch_model.dart';
import 'package:mvvm/model/company_execution_model.dart';
import 'package:mvvm/model/customer_wise_model.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/respository/branch_repository.dart';
import 'package:mvvm/respository/company_execution_repository.dart';
import 'package:mvvm/respository/heirarchy%20repository.dart';
import 'package:mvvm/view/Executive_sale/Company_wise/Company_wise.dart';
import 'package:mvvm/view/Executive_sale/Customer_wise/customer_wise.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import '../../../data/response/api_response.dart';
import '../../../model/heirarchy_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../model/team_company.dart';


class SalesHeirarchyViewModel with ChangeNotifier {
  bool _dataFetched = false;
  List<Customer> customerList = [];
  List<UserDetails> user = [];
  List<company_execution_model> team = [];
  List<Team_compnay> company = [];
  String reporting = '${empcode.auth}';
  final _salesRepo = HeirarchyRepository();
  final teamcom = company_execution_Repository();
  final branchcom = branch_Repository();

  ApiResponse<List<UserDetails>> heirarchyList = ApiResponse.loading();
  ApiResponse<List<company_execution_model>> teamcomapny = ApiResponse
      .loading();
  ApiResponse<List<Branch_compnay>> branch = ApiResponse.loading();

  void setHeirarcyList(ApiResponse<List<UserDetails>> response) {
    heirarchyList = response;
    notifyListeners();
  }

  void teamcomapnyList(ApiResponse<List<company_execution_model>> response) {
    teamcomapny = response;
    notifyListeners();
  }

  void branchList(ApiResponse<List<Branch_compnay>> response) {
    branch = response;
    notifyListeners();
  }

  // Define your database instance
  late Database _database;

  Future<void> initializeDatabase() async {
    // Open or create the database
    _database = await openDatabase(
      join(await getDatabasesPath(), 'user_details8_database.db'),
      onCreate: (db, version)
       {

        db.execute('CREATE TABLE user_details(EmpDesignation TEXT, EmpCode TEXT PRIMARY KEY, EmpName TEXT, ReportTo TEXT, is_check INTEGER)', );
        db.execute('CREATE TABLE team_company(Product_Company_Name TEXT, Product_Company_ID TEXT, is_check INTEGER)',);
        db.execute(
  'CREATE TABLE branch(Branch_Branch_Report_Name TEXT, Branch_Branch_Code TEXT, is_check INTEGER )',
        );
        db.execute(
          'CREATE TABLE codes(Branch_Branch_Report_Name TEXT, Branch_Branch_Code TEXT, is_check INTEGER )',
        );
        db.execute(
          'CREATE TABLE IF NOT EXISTS selected_items(id INTEGER PRIMARY KEY, item TEXT)',
        );

      },
      version: 1,
    );
  }

  void updateIsCheckValue(String id, bool newValue) async {
    final Database db = await _database;

    await db.rawUpdate(
      'UPDATE team_company SET is_check = ? WHERE Product_Company_ID = ?',
      [newValue ? 1 : 0, id],
    );
    print(newValue);
    print(id);
  }
  void updateIsCheckValuebranch(String id, bool newValue) async {
    final Database db = await _database;
    // Use a loop to update each row individually
    await db.rawUpdate(
      'UPDATE branch SET is_check = ? WHERE Branch_Branch_Code = ?',
      [newValue ? 1 : 0, id],
    );
    print(newValue);
    print(id);
  }

  void updateCheck(bool newValue) async {
    final Database db = await _database;
    // Use a loop to update each row individually
    await db.rawUpdate(
      'UPDATE team_company SET is_check = ?',
      [newValue ? 1 : 0],
    );
    print(newValue);
  }
  void updateCheckbranch(bool newValue) async {
    final Database db = await _database;
    // Use a loop to update each row individually
    await db.rawUpdate(
      'UPDATE branch SET is_check = ?',
      [newValue ? 1 : 0],
    );
    print(newValue);
  }

  Future<List<Map<String, dynamic>>> getCheckboxes() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> checkboxes = await db.rawQuery('SELECT * FROM team_company');
    return checkboxes;
  }

  Future<List<String>> name() async {
    final Database db = await _database;
    // Fetch the names of companies where is_check is true
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT Product_Company_Name FROM team_company WHERE is_check = 1',
    );
    // Extract the names from the result and cast to List<String>
    List<String> companyNames = result.map((e) => e['Product_Company_Name'] as String).toList();
    return companyNames;
  }



  Future<void> deletetable() async {

    await _database.delete('user_details');
    await _database.delete('team_company');
    await _database.delete('branch');

    await _database.delete('codes');
  }
  Future<void> deletecompanytable() async {
    // Delete existing data in the table
    await _database.delete('team_company');
  }

  Future<void> saveItems(List<String> items) async {
    final Database db = await _database;
    await db.transaction((txn) async {
      for (String item in items) {
        await txn.rawInsert(
          'INSERT INTO selected_items(item) VALUES(?)',
          [item],
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> searchItems(TextEditingController searchTexts) async {
    final Database db = await _database;
    final String searchText = searchTexts.text;
    try {
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT * FROM team_company WHERE Product_Company_Name LIKE ?', ['%$searchText%']);
      print(result);
      return result;
    } catch (e) {
      print('Error searching items: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<Map<String, dynamic>>> searchbranch(TextEditingController searchTexts) async {
    final Database db = await _database;
    final String searchText = searchTexts.text;

    try {
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT * FROM branch WHERE Branch_Branch_Report_Name LIKE ?', ['%$searchText%']);
         print(result);
      return result;
    } catch (e) {
      print('Error searching items: $e');
      return []; // Return an empty list if an error occurs
    }
  }

// Example usage




  Future<void> printUserDetailsFromDatabase(String reportingToValue,
      String reporting_to) async {
    final userDetailsList = await select(reportingToValue, reporting_to);

    for (var userDetails in userDetailsList) {
      print('Emp Code: ${userDetails.empCode}');
      print('Emp Name: ${userDetails.empName}');
      print('Reporting To: ${userDetails.reportingTo}');
      print('Designation: ${userDetails.designation}');
      print('Is Check: ${userDetails.isCheck}');
      print(''); // Add an empty line for separation
    }
  }

  Future<void> printtableFromDatabase() async {
    final userDetailsList = await fetchdata();
    for (var userDetails in userDetailsList) {
      print('Company Name: ${userDetails.companyName}');
      print('Company ID: ${userDetails.companyID}');
      // Add an empty line for separation
    }
  }


  Future<bool> isDatabaseTableEmpty() async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        'SELECT COUNT(*) as count FROM user_details');
    final int? count = Sqflite.firstIntValue(result);
    return count == 0;
  }

  Future<String> untaggedCode() async {
    try {
      final List<Map<String, dynamic>> result = await _database.rawQuery(
          "SELECT EmpCode FROM user_details WHERE EmpName='Untagged'");

      if (result.isNotEmpty) {
        String empCodes = result.map((row) => '${row['EmpCode']}').join(', ');
        return empCodes;
      } else {
        return '';
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  Future<void> printUntaggedEmpCodes() async {
    try {
      String empCodes = await untaggedCode();


      if (empCodes.isNotEmpty) {
        print('Employee Codes: $empCodes');
      } else {
        print('No records found for "Untagged" EmpName.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveUserDetailsToLocalDatabase(
      List<UserDetails> userDetailsList) async {
    // Delete existing data in the table
    await _database.delete('user_details');

    // Insert additional row
    await _database.insert(
      'user_details',
      {
        'EmpCode': empcode.auth,
        'EmpName': empcode.name,
        'is_check': 1,
        'ReportTo': empcode.auth,
        'EmpDesignation': empcode.designation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert new data
    for (var userDetails in userDetailsList) {
      await _database.insert(
        'user_details',
        userDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    List<Map<String, dynamic>> allUserDetails = await _database.query(
        'user_details');

    // Print all user details
    for (var userDetails in allUserDetails) {
      print('EmpCode: ${userDetails['EmpCode']}');
    }
    _dataFetched = true;
  }

  Future<void> fetchHeirarchyListApi() async {
    setHeirarcyList(ApiResponse.loading());

    try {
      final List<UserDetails> value = await _salesRepo.fetchUserDetails();


      if (value.isNotEmpty) {
        // Save the fetched data to the local database
        await _saveUserDetailsToLocalDatabase(value);

        // Set ApiResponse to completed if data is fetched successfully
        setHeirarcyList(ApiResponse.completed(value));
      } else {
        // Handle the case where data is empty
        setHeirarcyList(ApiResponse.error("User details are empty"));
      }
    } catch (error) {
      setHeirarcyList(ApiResponse.error(error.toString()));
    }
  }

  Future<void> _savedranchdetailsToLocalDatabase(
      List<Branch_compnay> teamcompanyList) async {
    // Delete existing data in the table
    await _database.delete('branch');

    // Insert new data
    for (var team in teamcompanyList) {
      await _database.insert(
        'branch',
        team.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _dataFetched = true;
    }
  }

  Future<List<Branch_compnay>> fetchbranchdata() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'branch',
      columns: [
        'Branch_Branch_Report_Name',
        'Branch_Branch_Code',
        'is_check'
      ],
    );


    return List.generate(maps.length, (i) {
      return Branch_compnay(
          BranchName: maps[i]['Branch_Branch_Report_Name'],
          BranchID: int.parse(maps[i]['Branch_Branch_Code']),
          ischecked: maps[i]['is_check'] == 1

      );
    });
  }


  Future<List<UserDetails>> select(String empcode, String isfirst) async {
    if (empcode == '99938') {
      if (isfirst == '1') {


        final List<Map<String, dynamic>> maps = await _database.query(
          'user_details',
          columns: [
            'EmpDesignation',
            'EmpCode',
            'EmpName',
            'ReportTo',
            'is_check'
          ],
          where: 'EmpCode = ? ',
          whereArgs: [empcode],
          groupBy: 'EmpName',
        );

        // Convert the List<Map> to a List<UserDetails>
        return List.generate(maps.length, (i) {
          return UserDetails(
            designation: maps[i]['EmpDesignation'],
            empCode: maps[i]['EmpCode'],
            empName: maps[i]['EmpName'],
            reportingTo: maps[i]['ReportTo'],
            isCheck: maps[i]['is_check'] == 0, // SQLite stores boolean as integers (0 or 1)
          );
        });
      }
      else {
        /// heirarchy
        final List<Map<String, dynamic>> maps = await _database.query(
          'user_details',
          columns: [
            'EmpDesignation',
            'EmpCode',
            'EmpName',
            'ReportTo',
            'is_check'
          ],
          where: 'ReportTo = ? AND EmpCode != ReportTo',
          whereArgs: [empcode],
          groupBy: 'EmpName',
        );


        // Convert the List<Map> to a List<UserDetails>
        return List.generate(maps.length, (i) {
          return UserDetails(
            designation: maps[i]['EmpDesignation'],
            empCode: maps[i]['EmpCode'],
            empName: maps[i]['EmpName'],
            reportingTo: maps[i]['ReportTo'],
            isCheck: maps[i]['is_check'] ==
                0, // SQLite stores boolean as integers (0 or 1)
          );
        }
        );
      }
    }
    else {
      if (isfirst == '1') {
        /// heirarchy
        ///

        final List<Map<String, dynamic>> maps = await _database.query(
          'user_details',
          columns: [
            'EmpDesignation',
            'EmpCode',
            'EmpName',
            'ReportTo',
            'is_check'
          ],
          where: 'EmpCode = ? ',
          whereArgs: [empcode],
          //groupBy: 'emp_name',
        );

        // Convert the List<Map> to a List<UserDetails>
        return List.generate(maps.length, (i) {
          return UserDetails(
            designation: maps[i]['EmpDesignation'],
            empCode: maps[i]['EmpCode'],
            empName: maps[i]['EmpName'],
            reportingTo: maps[i]['ReportTo'],
            isCheck: maps[i]['is_check'] ==
                0, // SQLite stores boolean as integers (0 or 1)
          );
        });
      }
      else {

        final List<Map<String, dynamic>> maps = await _database.query(
          'user_details',
          columns: [
            'EmpDesignation',
            'EmpCode',
            'EmpName',
            'ReportTo',
            'is_check'
          ],
          where: 'ReportTo = ? AND EmpCode != ReportTo',
          whereArgs: [empcode],
        );


        return List.generate(maps.length, (i) {
          return UserDetails(
            designation: maps[i]['EmpDesignation'],
            empCode: maps[i]['EmpCode'],
            empName: maps[i]['EmpName'],
            reportingTo: maps[i]['ReportTo'],
            isCheck: maps[i]['is_check'] ==
                0, // SQLite stores boolean as integers (0 or 1)
          );
        }
        );
      }
    }
  }

////////////////////////////////////////////team//////////////////////////////
  Future<List<Team_compnay>> fetchdata() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'team_company',
      columns: [
        'Product_Company_Name',
        'Product_Company_ID',
        'is_check'
      ],
    );

    //print('Query Result: $maps');  // Add this line

    return List.generate(maps.length, (i) {
      return Team_compnay(
          companyID: maps[i]['Product_Company_Name'],
          companyName: maps[i]['Product_Company_ID'],
          ischecked: maps[i]['is_check'] == 1

      );
    });
  }

  Future<void> _savetabledetailsToLocalDatabase(
      List<company_execution_model> teamcompanyList) async {
    // Delete existing data in the table
    await _database.delete('team_company');

    // Insert new data
    for (var team in teamcompanyList) {
      await _database.insert(
        'team_company',
        {
          'Product_Company_ID': team.Compnay_ID,
          'Product_Company_Name': team.Company,
          'is_check': team.is_check
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    _dataFetched = true;
  }

  Future<void> fetchTeamCompanyApi() async {
    teamcomapnyList(ApiResponse.loading());

    try {
      final List<company_execution_model> value = await teamcom.fetchData();

      if (value.isNotEmpty) {
        // Save the fetched data to the local database
        await _savetabledetailsToLocalDatabase(value);
        print('Fetched Team Company Data: $value');
        // Set ApiResponse to completed if data is fetched successfully
        teamcomapnyList(ApiResponse.completed(value));
      } else {
        // Handle the case where data is empty
        teamcomapnyList(ApiResponse.error("Team company details are empty"));
      }
    } catch (error) {
      teamcomapnyList(ApiResponse.error(error.toString()));
    }
  }

  Future<void> fetchbranchapi() async {
    branchList(ApiResponse.loading());

    try {
      final List<Branch_compnay> value = await branchcom
          .team_company_fetchData();

      if (value.isNotEmpty) {
        // Save the fetched data to the local database
        await _savedranchdetailsToLocalDatabase(value);
        print('Fetched Branch Company Data: $value');
        // Set ApiResponse to completed if data is fetched successfully
        branchList(ApiResponse.completed(value));
      } else {
        // Handle the case where data is empty
        branchList(ApiResponse.error("Branchdetails are empty"));
      }
    } catch (error) {
      teamcomapnyList(ApiResponse.error(error.toString()));
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.ligthgreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: AppColors.ligthgreen),
          ),
          elevation: 5,
          title: Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Container(
            height: 40,
            width: 0,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.ligthgreen,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6'
  ];

  List<bool> selectedItems = List.generate(6, (index) => false);
  List<bool> selectedItem = List.generate(6, (index) => false);
  void showCustomerWiseDialog(
      BuildContext context, String emp_code,
      String startdate, String enddate, String name, List<int> company,
      List<int> branch, List<String> measure) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.greencolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            
          ),
          elevation: 5,
          title: Center(
            child: Text(
              "Select any one",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8, // Adjust the width as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close the dialog
                      // Open your Customer Wise page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              customer_wise(
                                emp_code,
                                startdate,
                                enddate,
                                empCode: emp_code,
                                startDate: startdate,
                                endDate: enddate,
                                name: name,
                                companylist: company,
                                branchlist: branch, selectedmeasures: measure,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primary, // Button background color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Text(
                      "Customer Wise",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02,
                ), // Add some space between buttons
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Open your Company Wise page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              company_wise(

                                empCode: emp_code,
                                startDate: startdate,
                                endDate: enddate,
                                name: name,
                                companylist: company,
                                branchlist: branch, selectedmeasures: measure,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary:  AppColors.primary, // Button background color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Text(
                      "Company Wise",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  // List<String> selectedToAdd = [];
  // List<String> filteredItems = [];
  //
  // void refreshSelectedToAdd() {
  //   // Add your logic here to refresh selectedToAdd
  //   selectedToAdd = []; // For example, set selectedToAdd to an empty list
  // }
  // void showDropdownCheckbox(
  //     BuildContext context,
  //     List<String> items,
  //     List<String> initialSelectedValues,
  //     String title,
  //     List<bool> check,
  //     void Function(List<String> selectedValuese) onDone,
  //     void Function() onTapDone,
  //
  //     ) {
  //   double screenHeight = MediaQuery.of(context).size.height;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //
  //   filteredItems = List.from(items);
  //   selectedItems = List.generate(items.length, (index) => initialSelectedValues.contains(items[index]),
  //   );
  //  // check = List.generate(items.length, (index) => false);
  //  // List<int> check = List.generate(items.length, (index) => 1);
  //  //  fetchCheckedItemsFromSQLite().then((checkedItems) {
  //  //    selectedToAdd.addAll(checkedItems);
  //  //    notifyListeners(); // Notify listeners of the ChangeNotifier
  //  //  });
  //
  //
  //  // selectedToAdd = List.from(initialSelectedValues);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Center(
  //               child: Text(
  //                 title,
  //                 style: TextStyle(color: Colors.green[800]),
  //               ),
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             backgroundColor: Colors.white,
  //             content: Container(
  //               height: screenHeight * 0.8,
  //               width: screenWidth * 1,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               padding: EdgeInsets.all(8),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     height: 35,
  //                     decoration: BoxDecoration(
  //                       color: Colors.green[800],
  //                       borderRadius: BorderRadius.circular(17),
  //                     ),
  //                     margin: EdgeInsets.symmetric(vertical: 8),
  //                     padding: EdgeInsets.symmetric(horizontal: 12),
  //                     child: Center(
  //                       child: TextField(
  //                         textAlign: TextAlign.start,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             filteredItems = items
  //                                 .where((item) =>
  //                                 item.toLowerCase().contains(
  //                                     value.toLowerCase()))
  //                                 .toList();
  //                           });
  //                         },
  //                         style: TextStyle(color: Colors.white),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: 'Search',
  //                           hintStyle: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 15,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Container(
  //                       child: SizedBox(
  //                         height: 30,
  //                         child: ListView.builder(
  //                           itemCount: selectedToAdd.length,
  //                           scrollDirection: Axis.horizontal,
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, index) {
  //                             final item = selectedToAdd[index];
  //                             return Container(
  //                               padding: EdgeInsets.symmetric(horizontal: 4),
  //                               child: Chip(
  //                                 backgroundColor: Colors.green.shade100,
  //                                 label: Text(
  //                                   item,
  //                                   style: TextStyle(fontSize: 12),
  //                                 ),
  //                                 // onDeleted: () {
  //                                 //   setState(() {
  //                                 //     int itemIndex = items.indexOf(item);
  //                                 //     if (itemIndex != -1) {
  //                                 //       selectedItems[itemIndex] = false;
  //                                 //     }
  //                                 //     selectedToAdd.removeAt(index);
  //                                 //   });
  //                                 // },
  //                               ),
  //                             );
  //                           },
  //                         ),
  //
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       children: [
  //                         Expanded(
  //                           child: ListView.builder(
  //                             itemCount: filteredItems.length,
  //                             itemBuilder: (context, index) {
  //                               return
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                       children: [
  //
  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: Text(filteredItems[index].toString(),
  //                                           style: TextStyle(color: Colors.green[800]),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                         Checkbox(
  //                                           value: check[index], // Use the value at the index
  //                                           activeColor: Colors.green, // Set the active color to green
  //                                           onChanged: (value) {
  //                                             setState(() {
  //                                               check[index] = value ?? false; // Update the value at the index
  //                                               if (value ?? false) {
  //                                                 selectedToAdd.add(filteredItems[index]);
  //                                               } else {
  //                                                 selectedToAdd.remove(filteredItems[index]);
  //                                               }
  //                                             });
  //                                           },
  //                                         )
  //
  //
  //
  //                                       ]);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     width: double.infinity,
  //                     margin: EdgeInsets.symmetric(vertical: 8),
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         Navigator.of(context).pop();
  //                         // await saveSelectedItems(selectedToAdd);
  //                         List<String> selectedItemsList = [];
  //                         for (int i = 0; i < items.length; i++) {
  //                           if (selectedItems[i]) {
  //                             selectedItemsList.add(items[i]);
  //                           }
  //                         }
  //                         List<String> codes = selectedToAdd.map((item) {
  //                           // Split each item by ' - ' and get the last part (which should be the code)
  //                           List<String> parts = item.split(' - ');
  //                           return parts.isNotEmpty ? parts.last : ''; // Return the code part or an empty string if parts is empty
  //                         }).toList();
  //                         onDone(codes);
  //                         updateIsCheckValue(check);
  //                         print("selectedtoadd: $selectedToAdd");
  //                         onTapDone();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.green[800],
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                       child:
  //                       Text('Done', style: TextStyle(color: Colors.white)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }


  List<String> selectedToAdd = [];
  List<String> selectedbranch = [];
  List<String> filteredItembranch = [];
  bool selectal = false;

  void refreshSelectedToAddbranch()
  {
    selectedToAdd = [];
    selectedbranch = [];
  }
  void showDropdownCheckbox(BuildContext context, List<String> items, List<String> item, List<String> initialSelectedValues, String title, List<bool> check, void Function(List<String> selectedValuese) onDone, void Function() onTapDone,) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    filteredItembranch = List.from(items);

    selectedItems = List.generate(
      items.length, (index) => initialSelectedValues.contains(items[index]),
    );

    TextEditingController _textEditing = TextEditingController();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(color: AppColors.greencolor),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              content:
              Container(
                height: screenHeight * 0.8,
                width: screenWidth * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                //padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                     selectedTabIndex ==0 ?
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color:AppColors.greencolor,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: TextField(
                          textAlign: TextAlign.start,
                          onChanged: (value) async {
                            setState(() {
                              if(_textEditing==''){
                                filteredItembranch = List.from(items);
                              }
                              searchbranch(_textEditing).then((searchResult) {
                                filteredItembranch = searchResult.map((map) => '${map['Branch_Branch_Report_Name']} - ${map['Branch_Branch_Code']}').toList();
                                check = searchResult.map((map) => map['is_check'] == 1).toList();
                              });

                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
:
                  Container(
                  height: 35,
                  decoration: BoxDecoration(
                  color: AppColors.greencolor,
                  borderRadius: BorderRadius.circular(17),
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
            child: TextField(
            textAlign: TextAlign.start,
            onChanged: (value) async {
            setState(() {
            if(_textEditing==''){
            filteredItembranch = List.from(items);
            }
            searchbranch(_textEditing).then((searchResult) {
            filteredItembranch = searchResult.map((map) => '${map['Branch_Branch_Report_Name']} - ${map['Branch_Branch_Code']}').toList();
            check = searchResult.map((map) => map['is_check'] == 1).toList();
            });

            });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search Branch',
            hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 15,
            ),
            ),
            ),
            ),
            ),
                    // if (title=="Select Branches")
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: [
                            Container(
                              child: SizedBox(
                                height: 30,
                                child:

                                ListView.builder(
                                  itemCount: selectedToAdd.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final item = selectedToAdd[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Chip(
                                        backgroundColor: AppColors.ligthgreenshade,
                                        label: Text(
                                          item,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ),

                          ]),


                    ),
                    Row(
                      children: [
                        Text(""),
                        Spacer(),
                        Checkbox(
                          value: selectal,
                          activeColor: AppColors.greencolor,
                          // Set the active color to green
                          onChanged: (value) {
                            setState(() {
                              selectal = value ?? false;
                              if (selectal) {
                                for (int i = 0; i < check.length; i++) {
                                  check[i] = true;

                                  selectedToAdd.add(items[i]);
                                }
                              } else {
                                for (int i = 0; i < check.length; i++) {
                                  check[i] = false;
                                  selectedToAdd.remove(items[i]);
                                }
                              }
                            });
                          },
                        ),

                        Text('Select All', style: TextStyle(
                            color: AppColors.greencolor, fontSize: 12),),
                        SizedBox(width: 10,),
                        Container(
                          height: 20,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectal = false;
                                if (selectal) {
                                  for (int i = 0; i < check.length; i++) {
                                    check[i] = true;

                                    selectedToAdd.add(items[i]);
                                  }
                                } else {
                                  for (int i = 0; i < check.length; i++) {
                                    check[i] = false;
                                    selectedToAdd.remove(items[i]);
                                  }
                                }
                                selectedToAdd.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              // Set the background color to red
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Clear', style: TextStyle(
                                color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      ],),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child:
                            ListView.builder(
                              itemCount: filteredItembranch.length,
                              itemBuilder: (context, index) {
                                return
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child:

                                            Text(
                                              filteredItembranch[index].toString(),
                                              style: TextStyle(
                                                  color: Colors.green[800]),
                                            ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: check[index],
                                          // Use the value at the index
                                          activeColor: Colors.green,
                                          // Set the active color to green
                                          onChanged: (value) {
                                            setState(() {
                                              check[index] = value ??
                                                  false; // Update the value at the index
                                              if (value ?? false) {
                                                //.print(filteredItem[index].split(' - ')[1]);
                                                selectedToAdd.add(filteredItembranch[index]);
                                                updateIsCheckValuebranch(filteredItembranch[index].split(' - ')[1], true);
                                              } else {
                                                selectedToAdd.remove(filteredItembranch[index]);
                                                updateIsCheckValuebranch(filteredItembranch[index].split(' - ')[1], false);
                                              }
                                            });
                                          },
                                        )


                                      ]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          // await saveSelectedItems(selectedToAdd);
                          List<String> selectedItemsList = [];
                          for (int i = 0; i < items.length; i++) {
                            if (selectedItems[i]) {
                              selectedItemsList.add(items[i]);
                            }
                          }
                          List<String> codes = selectedToAdd.map((item) {
                            // Split each item by ' - ' and get the last part (which should be the code)
                            List<String> parts = item.split(' - ');
                            return parts.isNotEmpty
                                ? parts[1]
                                : ''; // Return the code part or an empty string if parts is empty
                          }).toList();
                          if (title == "Select Companies") {
                            ///updateIsCheckValue(check);
                            //fetchData();
                          }
                          onDone(codes);

                          print("selectedtoadd: $selectedToAdd");
                          onTapDone();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.greencolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                        Text('Done', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  ///////////////////////////////////////////////////////////////////////////////////////


  List<String> selectedToAd = [];
  List<String> filteredItem = [];
  List<String> filteredItems = [];
  bool selectall = false;
  TextEditingController _textEditing = TextEditingController();
  TextEditingController _textEditingbranch = TextEditingController();
  void refreshSelectedToAddcompany() {

    selectedToAd = [];

  }
  int selectedTabIndex = 0;
  Future<void> showDropdownCheckboxs(
      BuildContext context,
      List<String> branch,
      List<String> items,
      List<String> initialSelectedValues,
      String title,
      List<bool> check,
      List<bool> checkbranch,
      void Function(List<String> selectedValuese) onDone,
      void Function(List<String> branch) branchvalues,
      void Function() onTapDone,) async {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    List<String> selectedToAdSearch = List.from(initialSelectedValues);
    filteredItem = List.from(items);
filteredItems=List.from(branch);
    selectedItems = List.generate(
      items.length, (index) => initialSelectedValues.contains(items[index]),
    );
    filteredItembranch = List.from(items);
    selectedItems = List.generate(
      items.length, (index) => initialSelectedValues.contains(items[index]),
    );
    List<Team_compnay> teams = [];

    // Use the names list here
    TextEditingController _textEditingController = TextEditingController();



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DefaultTabController(
              length: 2, // Number of tabs
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlertDialog(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                  content: Container(
                   height: screenHeight * 0.8,
                    width: screenWidth * 1.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: AppColors.greencolor,
                          unselectedLabelColor: Colors.black,
                          onTap: (index) {
                            setState(() {
                              selectedTabIndex = index;
                              print(check);
                            });
                          },
                          tabs: [
                            Tab(text: 'Company'),
                            Tab(text: 'Branches'), // Change tab name to 'Company'
                          ],
                        ),

                        Expanded(
                          child:
                          TabBarView(
                            children: [

                              Container(

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          height: 30,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            color: AppColors.greencolor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Center(
                                            child:
                                            TextField(
                                              controller: _textEditingController,
                                              textAlign: TextAlign.start,
                                              onChanged: (value) async {
                                                setState(() {
                                                  if(_textEditingController==''){
                                                    filteredItems = List.from(items);
                                                  }
                                                  searchItems(_textEditingController).then((searchResult) {
                                                    filteredItem = searchResult.map((map) => '${map['Product_Company_Name']} - ${map['Product_Company_ID']}').toList();
                                                    check = searchResult.map((map) => map['is_check'] == 1).toList();
                                                  });

                                                });
                                              },
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(14), // Adjust vertical padding here
                                                border: InputBorder.none,
                                                hintText: 'Search',
                                                hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),


                                              ),
                                            ),

                                          ),
                                        ),
                                       InkWell(
                                         onTap: (){
                                           setState(() {
                                             selectall = false;
                                             if (selectall) {
                                               for (int i = 0; i < check.length; i++) {
                                                 check[i] = true;

                                                 selectedToAd.add(items[i]);
                                               }
                                             } else {
                                               for (int i = 0; i < check.length; i++) {
                                                 check[i] = false;
                                                 selectedToAd.remove(items[i]);
                                               }
                                             }
                                             selectedToAd.clear();
                                           });
                                         },
                                         child:
                                         Container(
                                        padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.red),
                                            child: Text('Clear', style: TextStyle(
                                                color: Colors.white, fontSize: 10)),
                                          ),)

                                      ],
                                    ),

                                    Row(
                                      children: [

                                        Spacer(),


                                        Text('Select All', style: TextStyle(
                                            color: AppColors.greencolor, fontSize: 12),),

                                        Checkbox(
                                          value: selectall,
                                          activeColor: AppColors.ligthgreen,
                                          // Set the active color to green
                                          onChanged: (value) {
                                            setState(() {
                                              selectall = value ?? false;
                                              if (selectall) {
                                                for (int i = 0; i < check.length; i++) {
                                                  check[i] = true;
                                                  if (title == "Select Companies") {
                                                    selectedToAd.add(items[i]);
                                                    updateCheck(true);
                                                  }
                                                }
                                              } else {
                                                for (int i = 0; i < check.length; i++) {
                                                  check[i] = false;
                                                  selectedToAd.remove(items[i]);
                                                  updateCheck(false);
                                                  selectedToAd=[];
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10,),


                                      ],),


                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child:
                                            ListView.builder(
                                              itemCount: filteredItem.length,
                                              itemBuilder: (context, index) {
                                                return

                                                  Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [

                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(
                                                                    2.0),
                                                                child:

                                                                Text(
                                                                  filteredItem[index].toString(),
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                      color: AppColors.greencolor,


                                                                  ),

                                                                ),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: check[index],
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  check[index] = value ?? false; // Update the value at the index
                                                                  if (value ?? false)  {
                                                                    selectedToAd.add(filteredItem[index]);
                                                                    updateIsCheckValue(filteredItem[index].split(' - ')[1], true);
                                                                    name();
                                                                  } else {
                                                                    selectedToAd.remove(filteredItem[index]);
                                                                    updateIsCheckValue(filteredItem[index].split(' - ')[1], false);
                                                                    name();
                                                                    // Data();
                                                                    // Pass the actual ID here
                                                                  }
                                                                });
                                                              },
                                                              activeColor: AppColors.greencolor,
                                                            )


                                                          ]),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Divider(color: AppColors.greencolor, height: 1),
                                                      ),
                                                    ],
                                                  );

                                              },

                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          // await saveSelectedItems(selectedToAdd);
                                          List<String> selectedItemsList = [];
                                          for (int i = 0; i < items.length; i++) {
                                            if (selectedItems[i]) {
                                              selectedItemsList.add(items[i]);
                                            }
                                          }
                                          List<String> codes = selectedToAd.map((item) {
                                            // Split each item by ' - ' and get the last part (which should be the code)
                                            List<String> parts = item.split(' - ');
                                            return parts.isNotEmpty
                                                ? parts[1]
                                                : '';
                                          }).toList();
                                          if (title == "Select Companies") {
                                          }
                                          onDone(codes);
                                          print(codes);

                                          print("selectedtoadd: $selectedToAd");
                                          onTapDone();
                                          name();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColors.greencolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child:
                                        Text('Done', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////branch
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          height: 30,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            color: AppColors.greencolor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          margin: EdgeInsets.symmetric(vertical: 13),
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
controller: _textEditingbranch,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    if(_textEditingbranch==''){
                                                      filteredItem = List.from(branch);
                                                    }
                                                    searchbranch(_textEditingbranch).then((searchResult) {
                                                      filteredItems = searchResult.map((map) => '${map['Branch_Branch_Report_Name']} - ${map['Branch_Branch_Code']}').toList();
                                                      checkbranch = searchResult.map((map) => map['is_check'] == 1).toList();
                                                    });

                                                  });
                                                },
                                                style: TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(10), // Adjust vertical padding here
                                                  border: InputBorder.none,
                                                  hintText: 'Search',
                                                  hintStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),

                                              ),
                                            ),

                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              selectal = false;
                                              if (selectal) {
                                                for (int i = 0; i < checkbranch.length; i++) {
                                                  checkbranch[i] = true;

                                                  selectedToAdd.add(branch[i]);
                                                }
                                              } else {
                                                for (int i = 0; i < checkbranch.length; i++) {
                                                  checkbranch[i] = false;
                                                  selectedToAdd.remove(branch[i]);
                                                }
                                              }
                                              selectedToAdd.clear();

                                            });
                                          },
                                          child:
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.red),
                                            child: Text('Clear', style: TextStyle(
                                                color: Colors.white, fontSize: 10)),
                                          ),)

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(""),
                                        Spacer(),


                                        Text('Select All', style: TextStyle(
                                            color: AppColors.greencolor, fontSize: 12),),
                                        Checkbox(
                                          value: selectal,
                                          activeColor: AppColors.greencolor,
                                          // Set the active color to green
                                          onChanged: (value) {
                                            setState(() {
                                              selectal = value ?? false;
                                              if (selectal) {
                                                for (int i = 0; i < checkbranch.length; i++) {
                                                  checkbranch[i] = true;

                                                  selectedToAdd.add(branch[i]);
                                                }
                                              } else {
                                                for (int i = 0; i < checkbranch.length; i++) {
                                                  checkbranch[i] = false;
                                                  selectedToAdd.remove(branch[i]);
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10,),

                                      ],),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child:
                                            ListView.builder(
                                              itemCount: filteredItems.length,
                                              itemBuilder: (context, index) {
                                                return
                                                  Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [

                                                            Expanded(
                                                             child:

                                                                Text(
                                                                  filteredItems[index].toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: AppColors.greencolor),
                                                                ),
                                                              ),

                                                              Checkbox(
                                                                value: checkbranch[index],
                                                                // Use the value at the index
                                                                activeColor: AppColors.greencolor,
                                                                // Set the active color to green
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    print('check: $check');
                                                                    print('checkbranch: $checkbranch');
                                                                    checkbranch[index] = value ??
                                                                        false; // Update the value at the index
                                                                    if (value ?? false) {
                                                                      //.print(filteredItem[index].split(' - ')[1]);
                                                                      selectedToAdd.add(branch[index]);
                                                                      updateIsCheckValuebranch(branch[index].split(' - ')[1], true);
                                                                    } else {
                                                                      selectedToAdd.remove(branch[index]);
                                                                      updateIsCheckValuebranch(branch[index].split(' - ')[1], false);
                                                                    }
                                                                  });
                                                                },
                                                              ),


                                                          ]
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Divider(color: AppColors.greencolor, height: 1),
                                                      ),
                                                    ],
                                                  );

                                              },
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),

                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            // await saveSelectedItems(selectedToAdd);
                                            List<String> selectedItemsList = [];
                                            for (int i = 0; i < branch.length; i++) {
                                              if (selectedItems[i]) {
                                                selectedItemsList.add(branch[i]);
                                              }
                                            }
                                            List<String> codes = selectedToAdd.map((item) {
                                              List<String> parts = item.split(' - ');
                                              return parts.isNotEmpty
                                                  ? parts[1]
                                                  : ''; // Return the code part or an empty string if parts is empty
                                            }).toList();
                                            if (title == "Select Companies") {
                                              ///updateIsCheckValue(check);
                                              //fetchData();
                                            }
                                            branchvalues(codes);

                                            print("selectedtoadd: $selectedToAdd");
                                            onTapDone();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.greencolor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child:
                                          Text('Done', style: TextStyle(color: Colors.white)),
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}







