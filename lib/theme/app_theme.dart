import 'package:flutter/material.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    // colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primaryColor),
    useMaterial3: true,
    primaryColor: CustomColors.primaryColor,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.jost(
        fontSize: 64.sp,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.jost(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.jost(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.textColor,
      ),
      displaySmall: GoogleFonts.jost(
        fontSize: 14.sp,
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    // colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primaryColor),
    useMaterial3: true,
    primaryColor: CustomColors.primaryColor,
    scaffoldBackgroundColor: CustomColors.scaffoldColor,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.jost(
        fontSize: 64.sp,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.jost(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.jost(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.textColorDark,
      ),
      displaySmall: GoogleFonts.jost(
        fontSize: 14.sp,
      ),
    ),
  );
}
