import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class datefixedcontainer extends StatefulWidget {
  final String title;
  final bool isvisible;
  final String name;
  const datefixedcontainer({Key? key, required this.title , required this.isvisible , required this.name}) : super(key: key);

  @override
  State<datefixedcontainer> createState() => _datefixedcontainerState();
}

class _datefixedcontainerState extends State<datefixedcontainer> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
          visible: widget.isvisible,
          child: Container(
            decoration: BoxDecoration(color: Colors.green[800],
            borderRadius: BorderRadius.circular(8)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                Text(widget.name, style: TextStyle(color: Colors.white)),

                        Text(widget.title, style: TextStyle(color: Colors.white),),


                ],
              ),
            ),
          ),

      ),
    );
  }
}
