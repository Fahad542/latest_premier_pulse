import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';


class RoundButton extends StatelessWidget {
    final String title ;
    final bool loading ;
    final VoidCallback onPress ;
    const RoundButton({Key? key ,
    required this.title,
    this.loading = false ,
    required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 45,
        width: 300,
        decoration: BoxDecoration(
          color:  AppColors.greencolor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
            child:loading ? CircularProgressIndicator(color: Colors.white,) :  Text(title ,
              style: TextStyle(color: AppColors.whiteColor,fontSize: 17 ),
            )),
      ),
    );
  }
}
