import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../res/color.dart';

class TextStyling {
  TextStyling._();
  static TextStyle extraBold24 = GoogleFonts.inter(fontSize: 24, color: AppColors.blackColor, fontWeight: FontWeight.w700);
  static TextStyle extraBold22 = GoogleFonts.inter(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w700);
  static TextStyle bold22 = GoogleFonts.inter(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600);
  static TextStyle bold20 = GoogleFonts.inter(fontSize: 20, color: AppColors.black, fontWeight: FontWeight.w600);
  static TextStyle bold18 = GoogleFonts.inter(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w600);
  static TextStyle text18 = GoogleFonts.inter(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w500);
  static TextStyle text16 = GoogleFonts.inter(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500);
  static TextStyle text14 = GoogleFonts.inter(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w500);
  static TextStyle text12 = GoogleFonts.inter(fontSize: 12, color: AppColors.black, fontWeight: FontWeight.w500);
  static TextStyle paragraph14 = GoogleFonts.inter(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w400);
  static TextStyle paragraph12 = GoogleFonts.inter(fontSize: 12, color: AppColors.black, fontWeight: FontWeight.w400);
  static TextStyle paragraph10 = GoogleFonts.inter(fontSize: 10, color: AppColors.black, fontWeight: FontWeight.w400);
}
