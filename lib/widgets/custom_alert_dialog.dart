import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CustomAlertDialog {
  static Future<void> showAlertDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titlePadding: EdgeInsets.all(0.w),
          backgroundColor: CustomColors.getContainerColor(),
          surfaceTintColor: Colors.transparent,
          content: Container(
            height: 280.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 150,
                  child: Lottie.asset(title == "success" ? "assets/icon/success.json" : "assets/icon/failed.json"),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // text: title == "success" ? "Payment Successful" : "Payment Failed",
                    text: content,
                    style: GoogleFonts.jost(
                      color: CustomColors.getTitleColor(),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // SizedBox(height: 10.h),
                // RichText(
                //   text: TextSpan(
                //     text: content,
                //     style: GoogleFonts.jost(
                //       color: CustomColors.getTextColor(),
                //       fontSize: 15.sp,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
