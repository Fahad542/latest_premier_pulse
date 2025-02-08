import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'Master_widgets.dart';

class shimmer_effect extends StatefulWidget {

  final bool isLoading;
   List<String>? selectedmeasures;
   bool companyanalysis;
   bool? tabs;

  shimmer_effect({
    this.selectedmeasures,
    required this.isLoading,
    this.tabs = true,
    this.companyanalysis =false

  }

  );

  @override
  _HeirarchyCardState createState() => _HeirarchyCardState();
}

class _HeirarchyCardState extends State<shimmer_effect> {
  final NumberFormat formatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child:

          widget.companyanalysis ==false ?
            TotalSalesCard(totalSale: '', title: '', )

    :

          Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child:
              Container(
                height: 330,
              color: Colors.grey,
              )
    ),),

            if(  widget.companyanalysis == false )
                   SizedBox(height: 60,),




              if( widget.companyanalysis == false)
            Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child:
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height:45,
              width: 360,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(8),
              ),
              ),

            ),


            SizedBox(height: 15,),
            if(widget.companyanalysis == false)
            Expanded(
                child:
    Shimmer.fromColors(
    baseColor: Colors.grey[600]!,
    highlightColor: Colors.grey[100]!,
    child:  ListView.builder(
                 
                   itemCount: 7,
                   itemBuilder: (BuildContext context, index)
               {
                 return

                   Container
                     (
                     height: widget.selectedmeasures!.isEmpty ? 60 : 88,
                     margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                     padding: EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: Colors.grey.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(12.0),
                       border: Border.all(color: Colors.grey.withOpacity(0.1)),),
                     );

               }

               ),
    )


    ),

            if( widget.companyanalysis == true )
              SizedBox( height: 50 ),
            if(  widget.companyanalysis == true)
    Shimmer.fromColors(
    baseColor: Colors.grey[100]!,
    highlightColor: Colors.grey[200]!,
    child: ListView.builder(
                shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, index) {

                    return Container(
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
color: Colors.white,
                          borderRadius: BorderRadius.circular(12),

                      ),
                    );

                  })


    )
          ],
        ),








        Positioned(
            top: widget.companyanalysis ==false ? 130 : 300,
            right: 0,
            left: 0,
            child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
          padding:  EdgeInsets.only(left: 15, right: 15),
          child:
          Container
            (
            height: 68,
            width: 30,
            margin: EdgeInsets.symmetric(horizontal: 20 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
             color: Colors.grey,
             ),
            )
             )
             ),
           )
      ],
    );
  }
}
