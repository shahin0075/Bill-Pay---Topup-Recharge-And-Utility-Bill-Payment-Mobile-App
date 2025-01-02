import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Spacer(),
        const Spacer(),
        Image.asset(
          image,
          width: 300.w,
          height: 300.h,
        ),
        // const Spacer(),
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyle(
            color: CustomColors.getTitleColor(),
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.getTextColor(),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
