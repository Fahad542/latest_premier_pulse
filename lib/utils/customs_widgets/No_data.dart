import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nodata extends StatefulWidget {
  const Nodata({super.key});

  @override
  State<Nodata> createState() => _NodataState();
}

class _NodataState extends State<Nodata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/nodata.png", height: 200,width: 200,),),
    );
  }
}
