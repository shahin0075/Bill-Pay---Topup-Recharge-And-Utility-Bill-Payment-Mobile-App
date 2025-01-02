import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/not_found.png",
              fit: BoxFit.contain,
              width: 240.w,
              height: 240.h,
            ),
            Text(
              errorMessage,
              style: GoogleFonts.jost(
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
