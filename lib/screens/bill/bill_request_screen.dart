import 'package:bill_payment/controller/bill_request_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:bill_payment/widgets/not_found.dart';
import 'package:bill_payment/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BillRequestScreen extends StatefulWidget {
  static const String routeName = "/billRequestScreen";
  const BillRequestScreen({super.key});

  @override
  State<BillRequestScreen> createState() => BillRequestScreenState();
}

class BillRequestScreenState extends State<BillRequestScreen> {
  final controller = Get.put(BillRequestController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    controller.fetchData();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels == controller.scrollController.position.maxScrollExtent) {
        controller.loadMoreData();
      }
    });
    languageData = languageController.getStoredData();
  }

  @override
  void dispose() {
    // controller.scrollController.dispose();
    Get.delete<BillRequestController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillRequestController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(BottomNavBar.routeName);
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              controller.currentPage = 1;
              controller.isLoading = true;
              controller.billRequestLists.clear();
            });
            await controller.fetchData();
          },
          color: CustomColors.primaryColor,
          child: Scaffold(
              backgroundColor: CustomColors.getBodyColor(),
              body: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            "assets/background.png",
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 50.h),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      hoverColor: CustomColors.primaryColor,
                                      padding: EdgeInsets.all(0.w),
                                      onPressed: () {
                                        Get.offAll(
                                          () => const BottomNavBar(selectedIndex: 0),
                                        );
                                      },
                                      icon: Icon(
                                        CupertinoIcons.back,
                                        color: Colors.white,
                                        size: 28.sp,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        languageData["Bill Pay Request"] ?? "Bill Pay Request",
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    IconButton(
                                      hoverColor: CustomColors.primaryColor,
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.search,
                                        color: Colors.white,
                                        size: 0.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 115.h),
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          controller.isLoading
                              ? Shimmer.fromColors(
                                  baseColor: CustomColors.getContainerColor(),
                                  highlightColor: CustomColors.getBodyColor(),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 7, // Number of shimmer items
                                    itemBuilder: (context, index) {
                                      return const ShimmerPreloader(); // Define ShimmerTransactionItem
                                    },
                                  ),
                                )
                              : controller.billRequestLists.isNotEmpty
                                  ? controller.isError
                                      ? NotFound(
                                          errorMessage: languageData["Error loading data. Please try again."] ??
                                              "Error loading data. Please try again.")
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: controller.billRequestLists.length,
                                          itemBuilder: (context, index) {
                                            final item = controller.billRequestLists[index];
                                            if (item.status.toLowerCase() == "success") {
                                              controller.statusIcon = CupertinoIcons.check_mark_circled;
                                              controller.statusColor = CustomColors.primaryColor;
                                              controller.statusBgColor = CustomColors.primaryLight2;
                                            } else if (item.status.toLowerCase() == "pending") {
                                              controller.statusIcon = Icons.restore_rounded;
                                              controller.statusColor = CustomColors.warningColor;
                                              controller.statusBgColor = CustomColors.warningLight;
                                            } else {
                                              controller.statusIcon = Icons.close;
                                              controller.statusColor = CustomColors.secondaryColor;
                                              controller.statusBgColor = CustomColors.secondaryLight;
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      titlePadding: EdgeInsets.all(0.w),
                                                      backgroundColor: CustomColors.getContainerColor(),
                                                      surfaceTintColor: Colors.transparent,
                                                      title: Stack(
                                                        children: [
                                                          Positioned.fill(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(10.w),
                                                                topRight: Radius.circular(10.w),
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
                                                                languageData["Details"] ?? "Details",
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
                                                                text: languageData["Trx Number"] ?? "Trx Number",
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
                                                                text: item.trxNumber.toString(),
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
                                                                text: languageData["Payable"] ?? "Payable",
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
                                                                text:
                                                                    "${item.payable.toString()} ${item.payableCurrency.toString()}",
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
                                                                text: languageData["Charge"] ?? "Charge",
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
                                                                text:
                                                                    "${item.charge.toString()} ${item.currency.toString()}",
                                                                style: GoogleFonts.jost(
                                                                  color: CustomColors.getTitleColor(),
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                            item.rejectedCause != null
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(height: 16.h),
                                                                      RichText(
                                                                        textAlign: TextAlign.center,
                                                                        text: TextSpan(
                                                                          text: languageData["Rejected Cause"] ??
                                                                              "Rejected Cause",
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
                                                                          text: item.rejectedCause != null
                                                                              ? item.rejectedCause.toString()
                                                                              : "",
                                                                          style: GoogleFonts.jost(
                                                                            color: CustomColors.getTitleColor(),
                                                                            fontSize: 16.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(height: 0.h)
                                                          ]),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h, bottom: 15.h),
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
                                                  borderRadius: BorderRadius.circular(16.w),
                                                ),
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                                                  leading: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16.w),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 45.w,
                                                          height: 45.h,
                                                          color: controller.statusBgColor,
                                                        ),
                                                        Positioned(
                                                            top: 11.h,
                                                            left: 11.w,
                                                            child: Icon(controller.statusIcon,
                                                                color: controller.statusColor)),
                                                      ],
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item.trxNumber,
                                                    maxLines: 1,
                                                    style: GoogleFonts.jost(
                                                      color: CustomColors.getTitleColor(),
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    item.method,
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
                                                        "${item.amount}${item.currency}",
                                                        style: GoogleFonts.jost(
                                                          color: controller.statusColor,
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        item.date.substring(0, 10),
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
                                          })
                                  : const NotFound(errorMessage: "No Data Available"),
                          if (controller.currentPage < controller.lastPage)
                            Container(
                              height: 100, // Customize the loading indicator's height
                              padding: EdgeInsets.only(bottom: 25.h),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                                strokeWidth: 2.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
