import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Attendance/Mark_Attandance/Mark%20Attendance_view.dart';
import 'package:mvvm/view/Company_analysis/Divisions/division_view.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:mvvm/view/Login_screen/login_view.dart';
import '../view/Executive_sale/Team_analysis/Team_analysis_view.dart';
import '../view/Home/conformation_popup.dart';
import '../view/Executive_sale/Team_analysis/Sales_viewmodel.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
final salesViewModel = SalesHeirarchyViewModel();

class _CustomDrawerState extends State<CustomDrawer> {
  final List<Widget> itemPages = [ HomeScreen() ];

  Map<String, bool> tileExpansionState = {};

  @override
  Widget build(BuildContext context) {
    final TextStyle whiteTextStyle = TextStyle(
      color: AppColors.greencolor, fontSize: 16,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(

        child: Stack(
          children: [
            Drawer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.greencolor,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50), // Half of the avatar's height/width
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.asset('assets/dp_default.png'),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 250,
                                  child: Text(
                                    empcode.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),

                      AnimatedCustomExpansionTile(
                        title: 'Sync',
                        children: <Widget>[  
                          ListTile(
                            title: Text(
                              'Data Sync',
                              style: TextStyle( color: AppColors.greencolor,fontSize: 13)
                            ),
                            leading: Icon(
                              Icons.calendar_today,
                              color: AppColors.greencolor,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Markattendance()));
                            },
                          ),
                        ],
                      ),
                      AnimatedCustomExpansionTile(
                        title: 'Executive Sale',
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Team Analysis',
                                style: TextStyle( color: AppColors.greencolor,fontSize: 13)
                            ),
                            leading: Icon(
                              Icons.group,
                              color: AppColors.greencolor,
                            ),
                            onTap: () async {
                              await salesViewModel.initializeDatabase();
                              final isTableEmpty =
                              await salesViewModel.isDatabaseTableEmpty();
                              if (!isTableEmpty) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Team_analysis()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Markattendance()));
                                Utils.flushBarErrorMessage(
                                    "Please Mark your attendance", context);
                              }
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Company Analysis',
                              style: whiteTextStyle.copyWith(fontSize: 13),
                            ),
                            leading: Icon(
                              Icons.business,
                              color: AppColors.greencolor,
                            ),
                            onTap: () async {
                              await salesViewModel.initializeDatabase();
                              final isTableEmpty =
                              await salesViewModel.isDatabaseTableEmpty();
                              if (!isTableEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => division()),
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Markattendance()));
                                Utils.flushBarErrorMessage(
                                    "Please Mark your attendance", context);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // This is the logout button placed at the bottom
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: RoundButton(
                title: 'LOGOUT',
                onPress: () {
                  showLogoutConfirmationDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  AnimatedCustomExpansionTile({required this.title, required this.children});

  @override
  _AnimatedCustomExpansionTileState createState() =>
      _AnimatedCustomExpansionTileState();
}

class _AnimatedCustomExpansionTileState extends State<AnimatedCustomExpansionTile> with SingleTickerProviderStateMixin

{
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          title: Text(
            widget.title,
            style: TextStyle(
                color: AppColors.greencolor,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          trailing: AnimatedCrossFade(
            firstChild: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.greencolor,
            ),
            secondChild: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.greencolor,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 300),
          child: Container(
            height: isExpanded ? null : 0,
            child: Column(
              children: widget.children,
            ),
          ),
        ),

      ],

    );
  }
}
