import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/controller/pusher_controller.dart';
import 'package:bill_payment/controller/transaction_controller.dart';
import 'package:bill_payment/screens/notification/notification_screen.dart';
import 'package:bill_payment/screens/profile/profile_setting_screen.dart';
import 'package:bill_payment/screens/transaction_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/bill_statistics.dart';
import 'package:bill_payment/widgets/shimmer_preloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final profileController = Get.put(ProfileController());
  final transactionController = Get.put(TransactionController());
  final notificationController = Get.put(PusherController());
  // language
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    profileController.fetchUserInfo();
    profileController.fetchDashboardData();
    transactionController.fetchData();
    notificationController.loadNotificationVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<TransactionController>(builder: (transactionController) {
        return GetBuilder<PusherController>(builder: (notificationController) {
          return GetBuilder<LanguageController>(builder: (languageController) {
            return RefreshIndicator(
              onRefresh: profileController.fetchDashboardData,
              color: CustomColors.primaryColor,
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: CustomColors.getBodyColor(),
                body: profileController.userData != null && profileController.dashboardData != null
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r),
                                  ),
                                  child: Image.asset(
                                    "assets/background.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20.h),
                                      ListTile(
                                        contentPadding: EdgeInsets.all(20.w),
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.r),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(ProfileSettingScreen.routeName);
                                            },
                                            child: Image.network(
                                              profileController.userData!.userImage,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        trailing: Stack(
                                          children: [
                                            notificationController.isNotificationVisible
                                                ? Positioned(
                                                    top: 9,
                                                    right: 12,
                                                    child: Container(
                                                      width: 10.w,
                                                      height: 10.h,
                                                      decoration: BoxDecoration(
                                                        color: CustomColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(
                                                          100.r,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            IconButton(
                                              hoverColor: CustomColors.primaryColor,
                                              onPressed: () async {
                                                setState(() {
                                                  notificationController.isNotificationVisible =
                                                      false; // Hide the notification count
                                                });
                                                await notificationController.saveNotificationVisibility(false);
                                                Get.toNamed(NotificationScreen.routeName);
                                              },
                                              icon: Icon(
                                                CupertinoIcons.bell,
                                                color: CustomColors.whiteColor,
                                                size: 28.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: Text(
                                          "${languageController.getStoredData()['Hello'] ?? 'Hello'} ${profileController.userData!.name}",
                                          style: GoogleFonts.jost(
                                            color: CustomColors.titleColor,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: Text(
                                          languageController.getStoredData()["Welcome Back"] ?? "Welcome Back",
                                          style: GoogleFonts.jost(
                                            color: CustomColors.titleColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: profileController.maximumHeight > 0
                                            ? Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 277.h,
                                                      padding: EdgeInsets.only(bottom: 10.h),
                                                      decoration: BoxDecoration(
                                                        color: CustomColors.getContainerColor(),
                                                        borderRadius: BorderRadius.circular(16.r),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: CustomColors.getShadowColor(),
                                                            blurRadius: 4,
                                                            spreadRadius: 0,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const Expanded(
                                                            child: BillStatistics(),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 10.h),
                                                            child: Text(
                                                              "Completed Bills",
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.getTitleColor(),
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.w),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: 13.h,
                                                            horizontal: 16.w,
                                                          ),
                                                          // height: 130.h,
                                                          width: 160.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(16.r),
                                                            color: CustomColors.getContainerColor(),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: CustomColors.getShadowColor(),
                                                                blurRadius: 4,
                                                                spreadRadius: 0,
                                                                offset: const Offset(0, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                    width: 40.w,
                                                                    height: 40.h,
                                                                    decoration: BoxDecoration(
                                                                      color: CustomColors.infoColor,
                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 8.h,
                                                                    left: 8.w,
                                                                    child: const Icon(
                                                                      CupertinoIcons.creditcard,
                                                                      color: CustomColors.whiteColor,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(height: 12.h),
                                                              Text(
                                                                languageController.getStoredData()["Wallet Balance"] ??
                                                                    "Wallet Balance",
                                                                style: GoogleFonts.jost(
                                                                  color: CustomColors.getTitleColor(),
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(height: 4.h),
                                                              Text(
                                                                "\$${profileController.dashboardData!.walletBalance}",
                                                                style: GoogleFonts.jost(
                                                                  color: CustomColors.getTitleColor(),
                                                                  fontSize: 18.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 16.h),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: 13.h,
                                                            horizontal: 16.w,
                                                          ),
                                                          // height: 130.h,
                                                          width: 160.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(16.r),
                                                            color: CustomColors.getContainerColor(),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: CustomColors.getShadowColor(),
                                                                blurRadius: 4,
                                                                spreadRadius: 0,
                                                                offset: const Offset(0, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                    width: 40.w,
                                                                    height: 40.h,
                                                                    decoration: BoxDecoration(
                                                                      color: CustomColors.secondaryColor,
                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 8.h,
                                                                    left: 8.w,
                                                                    child: const Icon(
                                                                      CupertinoIcons.refresh_thick,
                                                                      color: CustomColors.whiteColor,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(height: 12.h),
                                                              Text(
                                                                languageController.getStoredData()["Pending Bills"] ??
                                                                    "Pending Bills",
                                                                style: GoogleFonts.jost(
                                                                  color: CustomColors.getTitleColor(),
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(height: 4.h),
                                                              Text(
                                                                "${profileController.dashboardData!.pendingBills}",
                                                                style: GoogleFonts.jost(
                                                                  color: CustomColors.getTitleColor(),
                                                                  fontSize: 18.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 13.h,
                                                        horizontal: 16.w,
                                                      ),
                                                      // height: 130.h,
                                                      width: 160.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16.r),
                                                        color: CustomColors.getContainerColor(),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: CustomColors.getShadowColor(),
                                                            blurRadius: 4,
                                                            spreadRadius: 0,
                                                            offset: const Offset(0, 2),
                                                          )
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width: 40.w,
                                                                height: 40.h,
                                                                decoration: BoxDecoration(
                                                                  color: CustomColors.infoColor,
                                                                  borderRadius: BorderRadius.circular(10.r),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 8.h,
                                                                left: 8.w,
                                                                child: const Icon(
                                                                  CupertinoIcons.creditcard,
                                                                  color: CustomColors.whiteColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 12.h),
                                                          Text(
                                                            languageController.getStoredData()["Wallet Balance"] ??
                                                                "Wallet Balance",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            "\$${profileController.dashboardData!.walletBalance}",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 18.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.h),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 13.h,
                                                        horizontal: 16.w,
                                                      ),
                                                      // height: 130.h,
                                                      width: 160.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16.r),
                                                        color: CustomColors.getContainerColor(),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: CustomColors.getShadowColor(),
                                                            blurRadius: 4,
                                                            spreadRadius: 0,
                                                            offset: const Offset(0, 2),
                                                          )
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width: 40.w,
                                                                height: 40.h,
                                                                decoration: BoxDecoration(
                                                                  color: CustomColors.secondaryColor,
                                                                  borderRadius: BorderRadius.circular(10.r),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 8.h,
                                                                left: 8.w,
                                                                child: const Icon(
                                                                  CupertinoIcons.refresh_thick,
                                                                  color: CustomColors.whiteColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 12.h),
                                                          Text(
                                                            languageController.getStoredData()["Pending Bills"] ??
                                                                "Pending Bills",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            "${profileController.dashboardData!.pendingBills}",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 18.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      languageController.getStoredData()["Recent Transactions"] ??
                                          "Recent Transactions",
                                      style: GoogleFonts.jost(
                                        color: CustomColors.getTitleColor(),
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(TransactionScreen.routeName);
                                    },
                                    child: Text(
                                      languageController.getStoredData()["See All"] ?? "See All",
                                      style: GoogleFonts.jost(
                                        color: CustomColors.primaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            transactionController.isLoading
                                ? Shimmer.fromColors(
                                    baseColor: CustomColors.getContainerColor(),
                                    highlightColor: CustomColors.getBodyColor(),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 3, // Number of shimmer items
                                      itemBuilder: (context, index) {
                                        return const ShimmerPreloader(); // Define ShimmerTransactionItem
                                      },
                                    ),
                                  )
                                : transactionController.transactionLists.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          final item = transactionController.transactionLists[index];
                                          if (item.status.toLowerCase() == "success") {
                                            transactionController.statusIcon = CupertinoIcons.check_mark_circled;
                                            transactionController.statusColor = CustomColors.primaryColor;
                                            transactionController.statusBgColor = CustomColors.primaryLight2;
                                          } else if (item.status.toLowerCase() == "pending") {
                                            transactionController.statusIcon = Icons.restore_rounded;
                                            transactionController.statusColor = CustomColors.warningColor;
                                            transactionController.statusBgColor = CustomColors.warningLight;
                                          } else {
                                            transactionController.statusIcon = Icons.close;
                                            transactionController.statusColor = CustomColors.secondaryColor;
                                            transactionController.statusBgColor = CustomColors.secondaryLight;
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                    titlePadding: EdgeInsets.all(0.w),
                                                    backgroundColor: CustomColors.getContainerColor(),
                                                    surfaceTintColor: Colors.transparent,
                                                    title: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10.r),
                                                              topRight: Radius.circular(10.r),
                                                            ),
                                                            child: Image.asset(
                                                              "assets/background.png",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(20.w),
                                                          child: Center(
                                                            child: Text(
                                                              languageController.getStoredData()["Details"] ??
                                                                  "Details",
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.whiteColor,
                                                                fontSize: 20.sp,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text:
                                                                languageController.getStoredData()["Transaction ID"] ??
                                                                    "Transaction ID",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTextColor(),
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text: item.transactionId,
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16.h),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text: languageController.getStoredData()["Remarks"] ??
                                                                "Remarks",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTextColor(),
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text: item.remarks,
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16.h),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text: languageController.getStoredData()["Status"] ??
                                                                "Status",
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTextColor(),
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            text: item.status,
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.getTitleColor(),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h, bottom: 15.h),
                                              decoration: BoxDecoration(
                                                color: CustomColors.getContainerColor(),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: CustomColors.getShadowColor(),
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                                borderRadius: BorderRadius.circular(16.r),
                                              ),
                                              child: ListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                                                leading: ClipRRect(
                                                  borderRadius: BorderRadius.circular(16.r),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 45.w,
                                                        height: 45.h,
                                                        color: transactionController.statusBgColor,
                                                      ),
                                                      Positioned(
                                                          top: 11.h,
                                                          left: 11.w,
                                                          child: Icon(transactionController.statusIcon,
                                                              color: transactionController.statusColor)),
                                                    ],
                                                  ),
                                                ),
                                                title: Text(
                                                  item.remarks,
                                                  maxLines: 1,
                                                  style: GoogleFonts.jost(
                                                    color: CustomColors.getTitleColor(),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  item.type,
                                                  style: GoogleFonts.jost(
                                                    color: CustomColors.getTextColor(),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                trailing: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${item.symbol}${item.amount}",
                                                      style: GoogleFonts.jost(
                                                        color: transactionController.statusColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Text(
                                                      item.time.substring(0, 10),
                                                      style: GoogleFonts.jost(
                                                        color: CustomColors.getTextColor(),
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(top: 20.h, bottom: 60.h),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/not_found.png",
                                                fit: BoxFit.contain,
                                                width: 180.w,
                                                height: 180.h,
                                              ),
                                              Text(
                                                languageController.getStoredData()["No Transactions Available"] ??
                                                    "No Transactions Available",
                                                style: GoogleFonts.jost(
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                          strokeWidth: 2.0,
                        ),
                      ),
              ),
            );
          });
        });
      });
    });
  }
}
