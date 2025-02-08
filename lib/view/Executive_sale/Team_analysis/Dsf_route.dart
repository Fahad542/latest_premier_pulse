import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/Location_model.dart';
import '../../../res/color.dart';
import '../../../respository/location_repository.dart';
import '../../../utils/utils.dart';



class MapScreen extends StatefulWidget {
  final String dsfcode;
  final String date;
  final String name;
  final String code;

  MapScreen({required this.dsfcode, required this.date, required this.name, required this.code, Key? key, }): super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationResponse? data;
  GoogleMapController? mapController;
  List<LocationData> datalist = []; // Ensure it stores multiple LocationData objects
  bool isloading = false;
  Set<Marker> markers = {};
  static double? latitiude;
  static double? longitude;
  String formattedDate='';
  final repo = LoactionRepo();

  Future<void> fetch() async {
    setState(() {
      isloading = true;
    });
    String Datee=(widget.date).replaceAll(",", '-');
    DateTime date= DateTime.parse(Datee);
    formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      LocationResponse? datas = await repo.fectdata(widget.dsfcode, formattedDate);
      if (datas.status == 200) {
        //print("Fetched Data: ${data.latitude.toString()}, ${data.longitude.toString()}, ${data.locationTime.toString()}");
           data = datas;
           print("data hy :${data}");
        setState(() {
        //  datalist.add(data.data);

          _updateMarkers();
          isloading = false;
        });
      }
      else if (datas.status == 400) {
        Navigator.pop(context);
        Utils.flushBarErrorMessage("Locations Not Found", context);
        // setState(() {
        //   isloading = false;
        // });
        //
        // print("Error message shown, waiting 2 seconds...");
        //
        // Future.delayed(Duration(seconds: 2), () {
        //   print("2 seconds passed");
        //   if (mounted) {
        //     print("Closing the screen...");
        //     Navigator.pop(context); // Close the screen after 2 seconds
        //   } else {
        //     print("Widget is not mounted anymore");
        //   }
        // });
      }

    } catch (e) {
      print("Error: $e");

      setState(() {
        isloading = false;
      });
    }
  }


  void _updateMarkers() {
    Set<Marker> newMarkers = {};

    for (int i= 0; i <data!.data.length ; i++ ) {
          double lat = double.tryParse(data!.data[i].latitude) ?? 0.0;
    double lng = double.tryParse(data!.data[i].longitude) ?? 0.0;
          latitiude =double.tryParse(data!.data[0].latitude);
          longitude =double.tryParse(data!.data[0].longitude);
      newMarkers.add(
        Marker(
          markerId: MarkerId('${lat}_${lng}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: "Location",
            snippet: "Time: ${data!.data[i].locationTime}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
print("Markers: ${markers}");
  }

  static  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(latitiude!, longitude!), // Karachi coordinates
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greencolor,
        title: Text("Booking Map"),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary,))
          :

      data?.status == 200
      ?

      Stack(
        children:[
          GoogleMap(
          initialCameraPosition: _initialPosition,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
        ),
          Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child:

              Container(
                  decoration: BoxDecoration(
                    color: AppColors.greencolor, // Green color (use your AppColors.greencolor if defined)
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(12), // Add padding for spacing
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,  // Person icon
                        color: Colors.white,
                        size: 40,  // Adjust size as needed
                      ),
                      SizedBox(width: 12), // Add some space between icon and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "DSF Name: ",  // Label
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7), // Light color for label
                                      fontWeight: FontWeight.normal, // Light weight for label
                                      fontSize: 13, // Adjust font size as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${widget.name} (${widget.code})",  // Value
                                    style: TextStyle(
                                      color: Colors.white, // Dark color for value
                                  // Bold weight for value
                                      fontSize: 13, // Adjust font size as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Date TextSpan
                            SizedBox(height: 8), // Add some spacing between text elements
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Route Date: ",  // Label
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7), // Light color for label
                                      fontWeight: FontWeight.normal, // Light weight for label
                                      fontSize: 13, // Adjust font size as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: formattedDate,  // Value
                                    style: TextStyle(
                                      color: Colors.white, // Dark color for value
                                      // Bold weight for value
                                      fontSize: 13, // Adjust font size as needed
                                    ),
                                  ),

                                ],
                        ),
                      ),
                    ],
                  ),
                      )])
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.greencolor,
              //     borderRadius: BorderRadius.circular(8)
              //
              //   ),
              //
              //     margin: EdgeInsets.symmetric(horizontal: 20),
              //     child: Column(children: [
              //       Text( "DSF Name: ${widget.name} (${widget.code})", style: TextStyle(color: Colors.white),),
              //       Text("Date: ${formattedDate}", style: TextStyle(color: Colors.white),)
              //     ],)
              // )


              )) ]
      )
          : Container()
    );
  }
}
