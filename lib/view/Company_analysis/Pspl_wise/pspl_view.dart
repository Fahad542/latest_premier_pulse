import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/view/Company_analysis/Pspl_wise/pspl_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/customs_widgets/Custom_app_bar.dart';
import '../../../utils/customs_widgets/Master_widgets.dart';
import '../../../utils/customs_widgets/Popup_menu.dart';
import '../../../utils/customs_widgets/Shimmer_effect.dart';
import '../../../utils/customs_widgets/list_filters.dart';

class pspl_view extends StatefulWidget {
  final String name;
  DateTime? startdate;
  DateTime? enddate;
  pspl_view({Key? key, required this.name ,  this.startdate, this.enddate
  }) : super(key: key);

  @override
  State<pspl_view> createState() => _pspl_viewState();
}
late Pspl_view_model model;
class _pspl_viewState extends State<pspl_view> {

  @override
  void initState() {
    model = Pspl_view_model();
    model.initializeDates(widget.startdate, widget.enddate);
    getsale();
    super.initState();
  }
  void getsale() async {
    if(widget.name == "Company")
    {
      model.getdata(model.classname,[]);
    }
    else {
      model.getdata(model.classname,[widget.name]);
    }
  }

    @override
  Widget build(BuildContext context) {
    return

      ChangeNotifierProvider<Pspl_view_model>(
          create: (context) => model,
          child: Consumer<Pspl_view_model>(
          builder: (context, viewModel, child) {
            return
              Scaffold(
                  appBar: CustomAppBar(
                    title: widget.name,
                    actions: [
                      Icon(Icons.abc, color: AppColors.greencolor),
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
                          // MenuItem(
                          //     text: 'Measures',
                          //     icon: Icons.filter_list,
                          //     value: 'measures',
                          //     onTap: () {
                          //
                          //     }
                          // ),
                          MenuItem(
                            text: model.sortwithzero == false ? 'With 0s' : 'Without 0s', // Correct use of ternary operator
                            icon: Icons.list,
                            value: 'zero',
                            onTap: () {
                              print(model.sortwithzero ? 'With 0s' : 'Without 0s');
                              // Add your custom action here
                            },
                          )
                        ],
                        onSelected: (value) {
                          if (value == 'share') {
                            String combinedMessage = '';
                            combinedMessage += "Start Date: ${model.startDateFormatted}\nEnd Date: ${model.endDateFormatted}\n\n";

                            for (int i = 0; i < model.datalist.length; i++) {
                              // Assign the correct value to `name` based on the `classname`
                              String name = '';
                              if (model.classname == "Company") {
                                name = model.datalist[i]['Product_Company_Name'];
                              } else if (model.classname == "SubCategory") {
                                name = model.datalist[i]["Product_SubCategory_Name"];
                              } else if (model.classname == "Category") {
                                name = model.datalist[i]["Product_Category_Name"];
                              } else if (model.classname == "Brand") {
                                name = model.datalist[i]["Product_Brand_Name"];
                              } else if (model.classname == "Product") {
                                name = model.datalist[i]["Product_Product_Name"];
                              }

                              // Format the sales value
                              String sale = NumberFormat('#,###').format(
                                  double.parse(model.datalist[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0')
                              );
                              sale = sale.isEmpty ? '0' : sale;

                              // Add the formatted data to the combined message
                              combinedMessage += "Name: $name\nSale: $sale\n\n";
                            }

                            // Share the combined message
                            Share.share(combinedMessage, subject: 'Sales Information');
                          }

                          if (value == "measures") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return filters(
                                  onSelectionDone: (selectedValues) async {

                                      model.selectedmeasures = selectedValues.toList();
                                    getsale();

                                      model.datalist = model.datalist;
                                  model.notifyListeners();
                                  },
                                  selectedvalues: model.selectedmeasures,
                                );
                              },
                            );
                          }
                          if (value == "zero") {

                              model.sortwithzero = !model.sortwithzero;
                              model.notifyListeners();
                           ;
                          }
                        },

                      ),
                    ],
                  ),
body: model.isLoading ?
shimmer_effect( isLoading: model.isLoading , selectedmeasures: model.selectedmeasures,)
    :
    MasterView(

      rootontap: ()
      {
        model.clear();
        model.clearcodes();
        getsale();
      },

      stackontap: (index) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if(model.selecteditem[index]["category"] == "Category")
        {
          await prefs.remove('categorycode');
          await prefs.remove('subcategorycode');
          await prefs.remove('productcode');
          await prefs.remove('brandcode');
          model.items =["SubCategory", "Brand", "Product"];
          await model.getcodes();

        }
        if(model.selecteditem[index]["category"] == "SubCategory")
        {
          await prefs.remove('subcategorycode');
          await prefs.remove('productcode');
          await prefs.remove('brandcode');
          model.subcategorycode ='';
          model.productcode ='';
          model.brandcode ='';
          model.items =["Brand", "Product"];
         await model.getcodes();
        }
        if(model.selecteditem[index]["category"] == "Brand")
          {
            await prefs.remove('brandcode');
            await prefs.remove('productcode');

            model.items =["Product"];
           await model.getcodes();
          }
    
        model.selecteditem.removeRange(index + 1, model.selecteditem.length);
        model.classname = model.selecteditem[index]['category'];

        getsale();
        model.notifyListeners();
      },
     rootlist: model.selecteditem,
    sortdata: model.sortwithzero == false ? 'With Zero' : 'Without Zero',
  startDate: model.startDate,
  endDate: model.endDate,
  totalsaleTap: (){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pspl_view(name: "Company", startdate: model.startDate, enddate: model.endDate,
        ),
      ),
    );
  },
  apiResponseList: model.datalist,
  customCardWidget: (data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: HeirarchyCard(
        classname: model.classname,
        title:
        model.classname == "Company" ? data['Product_Company_Name']  :
        model.classname == "SubCategory" ? data["Product_SubCategory_Name"] :
        model.classname == "Category" ? data["Product_Category_Name"] :
        model.classname == "Brand" ? data["Product_Brand_Name"] :
        model.classname == "Product" ? data["Product_Product_Name"] :'',
        date:
       model.classname == "Company" ? data['Product_Company_Code'].toString()  :
       model.classname == "SubCategory" ? data['Product_SubCategory_Code'].toString()  :
       model.classname == "Category" ? data['Product_Category_Code'].toString()  :
       model.classname == "Brand" ? data['Product_Brand_Code'].toString()  :
       model.classname == "Product" ? data['Product_Product_Code'].toString()  :'',

          amount: data['Sales_Inc_ST'].toString(),

        designation: "",
        onTap: () async {
          if (model.items.isNotEmpty) {
            await model.savecodes(data);
            model.category(context, (value) async {
              model.addItemToSelected(value,
                  model.classname == "Company" ? data['Product_Company_Name']  :
                  model.classname == "SubCategory" ? data["Product_SubCategory_Name"] :
                  model.classname == "Category" ? data["Product_Category_Name"] :
                  model.classname == "Brand" ? data["Product_Brand_Name"] :
                  model.classname == "Product" ? data["Product_Product_Name"] :''
                 );

              await model.getcodes();
              getsale();
            }
            );

          }

        },
        getchannels: () async {
          await model.getchannel(data["Product_Company_Code"],);
          setState(() {
            model.total=0;
          });

          for (int i = 0; i < model.channel.length; i++) {

              model.total += int.tryParse(model.channel[i].Sales.replaceAll(',', '')) ?? 0;
              model.formattedTotalbranch = model.formatter.format(model.total);
          }
          model.showchannelDetailsDialog(context, model.channel,data["Product_Company_Code"].toString(), model.formattedTotalbranch.toString(),data["Product_Company_Name"].toString());
        },
        getbranches: () async {
          try {
            await model.getbracnhes(data["Product_Company_Code"],);
            setState(() {
              model.total = 0;
            });

            for (int i = 0; i < model.branches.length; i++) {
              model.total +=
                  int.tryParse(model.branches[i].Sales.replaceAll(',', '')) ??
                      0;
              model.formattedTotalbranch = model.formatter.format(model.total);
            }
            model.showCompanyDetailsDialog(context, model.branches,
                data["Product_Company_Code"].toString(),
                model.formattedTotalbranch.toString(),
                data["Product_Company_Name"].toString());
          }
          catch(e){
            print(e.toString());
          }

        },

        showsale: true,

        selectedmeasures: model.selectedmeasures,
        item: data,
        saleonTap: () {}, color: AppColors.primary,
      ),
    );
  },
  onStartDateSelected: (DateTime selectedStartDate)
  {
    setState(() {
      model.startDate = selectedStartDate;
      getsale();
    });
  },
  onEndDateSelected: (DateTime selectedEndDate) {
    setState(() {
      model.endDate = selectedEndDate;
      getsale();
    });
  }, title: '${widget.name} Total Sales',
),
                  );
          }));
  }
}
