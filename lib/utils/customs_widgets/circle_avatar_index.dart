import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Circle_avater extends StatefulWidget {
  final int index;
  const  Circle_avater({Key? key, required this.index}) : super(key: key);

  @override
  State< Circle_avater> createState() => _State();
}

class _State extends State< Circle_avater> {
  @override
  Widget build(BuildContext context) {
    return
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black,
                              child: Text(
                                "${widget.index}".toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9
                                ),
                              ),
                            ),
                          );

  }
}
