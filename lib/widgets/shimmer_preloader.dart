import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPreloader extends StatelessWidget {
  const ShimmerPreloader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h, bottom: 16.h),
      decoration: BoxDecoration(
        color: CustomColors.getContainerColor(),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getShadowColor(),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        leading: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 45.w,
            height: 45.h,
            color: Colors.white, // Shimmer effect will make it look like it's loading
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16.h,
            width: 200.w, // You can adjust the width to match your design
            color: Colors.white,
          ),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16.h,
            width: 100.w, // Adjust width as needed
            color: Colors.white,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: CustomColors.primaryColor,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 16.h,
                width: 50.w, // Adjust width as needed
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Shimmer.fromColors(
              baseColor: CustomColors.primaryColor,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 16.h,
                width: 70.w, // Adjust width as needed
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
