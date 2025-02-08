import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/respository/division_type_repository.dart';
import 'package:mvvm/utils/customs_widgets/Master_widgets.dart';
import 'package:mvvm/utils/customs_widgets/No_data.dart';
import 'package:share/share.dart';
import '../../../res/color.dart';
import '../../../respository/measure_repository.dart';
import '../../../utils/Drawer.dart';
import '../../../utils/customs_widgets/Custom_app_bar.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import '../Pspl_wise/pspl_view.dart';

class division extends StatefulWidget {
  const division({Key? key}) : super(key: key);

  @override
  State<division> createState() => _DivisionState();
}

class _DivisionState extends State<division> {
  List<dynamic> team = [];
  bool isLoading = false;
  num totalCompany = 0;
  String totalSale = '';
  bool showDateContainers = false;
  bool company = false;
  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate = DateTime.now();
  final formatter = NumberFormat('#,###');
  String startDateFormatted = '';
  String endDateFormatted = '';
  List<PieChartSectionData> pieSections = [];

  String getImagePath(String name) {
    const imagePaths = {
      "PCP": "assets/p-solid.png",
      "FMCG": "assets/f-solid.png",
      "CONSUMER": "assets/c-solid.png",
      "PHARMA": "assets/p-solid.png",
    };



    // Return the image path, defaulting to a placeholder if not found
    return imagePaths[name] ?? "assets/default-image.png";  // Default image if the name doesn't match
  }
  Future<void> getdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);

      team = await division_type_Repository().team_company_fetchData(startDateFormatted, endDateFormatted);
      double totalSales = team.fold(0, (sum, item) => sum + item['Sales_Inc_ST']);
      pieSections = team.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;
        double percentage = (data['Sales_Inc_ST'] / totalSales) * 100;
        return PieChartSectionData
          (

          color: getRandomColor(index),
          value: data['Sales_Inc_ST'] as double,
          title: "${data['Product_Class_Name']} \n${percentage.toStringAsFixed(2)}%",
          radius: 50,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),

          );

      }).toList();

      setState(() {
        totalSale = formatter.format(totalSales);
      });
      print('API Result: $team');

    } catch (e, stack) {
      setState(() {
        isLoading = false;
        showDateContainers = true;
        company = true;
      });
      print('Error: $e');
      print('stack: $stack');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Color getRandomColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case "PCP":
        return Icons.spa;
      case "FMCG":
        return Icons.shopping_cart;
      case "Groceries":
        return Icons.local_grocery_store;
      case "CONSUMER":
        return Icons.people;
      case "PHARMA":
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
  @override

  void initState()
  {
    super.initState();
    final repository = measure_repository();
    repository.fetchDataAndSave();
    getdata();
  }

  @override
  Widget build(BuildContext context)
  {
    return
      WillPopScope(
      onWillPop: () async {
        return
          await Exit.showExitDialog(context);
        }
        ,
      child: Scaffold(

        appBar:
        CustomAppBar
          (title: "Company Analysis",
          actions: [
            Icon(Icons.abc, color: AppColors.greencolor),
            MyPopupMenu(menuItems:
            [
              MenuItem
                (
                  text: 'Share',
                  icon: Icons.share,
                  value: 'share',
                  onTap: ()
                  {
                    print('Share selected');
                  },
                ),
            ],

              onSelected: (value) {
                if (value == 'share') {
                  String combinedMessage = '';
                  combinedMessage += "Start Date: $startDateFormatted\nEnd Date: $endDateFormatted\n\n";
                  for (int i = 0; i < team.length; i++) {
                    if (team[i]['Product_Class_Name'].isNotEmpty) {
                      String name = team[i]['Product_Class_Name'];
                      String sale = NumberFormat('#,###').format(double.parse(team[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));
                      sale = sale.isEmpty ? '0' : sale;

                      combinedMessage += "Name: $name\nSale: $sale\n\n";
                    }
                  }

                  Share.share(combinedMessage, subject: 'Sales Information');
                }
              },
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body:




        isLoading
            ?
        shimmer_effect( isLoading: isLoading ,companyanalysis: true)
            : Padding(
          padding: const EdgeInsets.all(0.0),
          child:

          team.isNotEmpty   ?

          Stack(
            children:[


              Column(
              children: [


                Container(
                  height: 330,
                  decoration: BoxDecoration(color: AppColors.greencolor),
                  child:
                                    Column(
                                      children: [
                                        Container(
                                          height: 300,
                                          child: InkWell(
                      onTap: (){

                      },
                      child: PieChart(
                        PieChartData(
                          sections: pieSections,
                          centerSpaceRadius: 80, // Adjust the center space radius if needed
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                                        ),
                                      ],
                                    ),

                ),

                SizedBox(height: 60,),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: team.length,

                      itemBuilder: (BuildContext, index){
                        final name = team[index]['Product_Class_Name'];
                        final sale = formatter.format(team[index]['Sales_Inc_ST']);
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pspl_view(
                              name: name,
                              startdate: startDate,
                              enddate: endDate,
                            ),
                          ),
                        );
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                   padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(12),
                                  color: getRandomColor(index).withOpacity(0.2)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Container(
                                      padding: EdgeInsets.all(6.0), // Padding around icon
                                      decoration: BoxDecoration(
                                        color: getRandomColor(index),
                                        borderRadius: BorderRadius.circular(6), // Rounded corners for the icon container
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Light shadow
                                            blurRadius: 4, // Blur effect for shadow
                                            spreadRadius: 1, // Spread effect for shadow
                                            offset: Offset(0, 2), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        getCategoryIcon(name), // Replace with the desired icon
                                        color: Colors.white, // Icon color
                                        size: 25, // Icon size
                                      ),
                                    ),
                                  SizedBox(width: 10,),
                                  Text(name, textAlign: TextAlign.center,),
                                  Spacer(),
                                  Text(
                                    "${sale} RS/=",

                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold, color: AppColors.greencolor),
                                  )
                                ],
                              )


                          ),
                        );
                      }),
                ),




              ],
            ),
              Positioned(
                top:  300,
                right: 0,
                left: 0,
                child: DateRangeSelector(
                  startDate: startDate,
                  endDate: endDate,
                  showDateContainers: true,
                  onStartDateSelected: (value){
                        setState(() {
              startDate = value;
              startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
              getdata();
            });
                  }, // Pass the callback for start date
                  onEndDateSelected: (value){
                    setState(() {
                      endDate = value;
                      endDateFormatted =DateFormat('yyyy,MM,dd').format(endDate!);
                      getdata();
                    });
                  }, // Pass the callback for end date
                ),
              ),

                    Positioned(
                      right: 0,
                      left: 0,
                      top: 125,
                      child: FittedBox(
                        fit: BoxFit.scaleDown, // Ensure the text scales to fit
                        child: Column(
                          children: [
                            Text(
                              "Total Sales",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15, // Default size


                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              totalSale,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Default size
fontWeight: FontWeight.bold,

                              ),
                            ),
                          ],
                        ),

          ),),
            ],
          )
              : Center(child: Nodata(),)
        ),
      ),
    );
  }
}









