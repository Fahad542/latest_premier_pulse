// import 'package:flutter/cupertino.dart';
//
// import '../../model/heirarchy_model.dart';
// import '../Sales/Sales_view.dart';
//
// class HomeViewModel with ChangeNotifier {
//   String empCodeString = '';
//   List<UserDetails> userDetailsList = [];
//
//   Future<void> loadUserDetails(String reporting, String reptto) async {
//     empCodeString = '';
//     userDetailsList.clear();
//     await salesViewModel.initializeDatabase();
//     final data = await salesViewModel.select(reporting, reptto);
//
//     userDetailsList = data;
//
//     for (final item in userDetailsList) {
//       final String id = item.empCode;
//
//       // Add a comma if empCodeString is not empty
//       if (empCodeString.isNotEmpty) {
//         empCodeString += ',';
//       }
//       empCodeString += '"$id"';
//     }
//
//     // Notify listeners that the state has changed
//     notifyListeners();
//   }
// }
