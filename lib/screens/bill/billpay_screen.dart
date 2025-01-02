import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/transaction_controller.dart';
import 'package:bill_payment/screens/bill/bill_pay_form_screen.dart';
import 'package:bill_payment/screens/transaction_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BillPayScreen extends StatefulWidget {
  static const String routeName = "/billPayScreen";
  const BillPayScreen({super.key});

  @override
  State<BillPayScreen> createState() => _BillPayScreenState();
}

class _BillPayScreenState extends State<BillPayScreen> {
  final controller = Get.put(BillPayController());
  final transactionController = Get.put(TransactionController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    controller.fetchBillingCategories();
    transactionController.fetchData();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(builder: (controller) {
      return GetBuilder<TransactionController>(builder: (transactionController) {
        return WillPopScope(
          onWillPop: () async {
            Get.offAllNamed(BottomNavBar.routeName);
            return true;
          },
          child: Scaffold(
            backgroundColor: CustomColors.getBodyColor(),
            body: controller.billingCategories != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.asset(
                                "assets/background.png",
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              child: Container(
                                margin: EdgeInsets.only(top: 60.h),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                        Text(
                                          languageData["Pay Bill"] ?? "Pay Bill",
                                          style: GoogleFonts.jost(
                                            color: Colors.white,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        IconButton(
                                          hoverColor: CustomColors.primaryColor,
                                          onPressed: () {},
                                          icon: Icon(
                                            CupertinoIcons.bell,
                                            color: Colors.white,
                                            size: 0.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 12.0,
                                        crossAxisSpacing: 12.0,
                                      ),
                                      itemCount: controller.billingCategories!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final item = controller.billingCategories![index];
                                        return GestureDetector(
                                          onTap: () =>
                                              Get.toNamed(BillPayFormScreen.routeName, arguments: item.key.toString()),
                                          child: Container(
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16.w),
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
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 48.w,
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12.w),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: Image.network(
                                                        item.image,
                                                        width: 48,
                                                        height: 48,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  item.name,
                                                  style: GoogleFonts.jost(
                                                    color: CustomColors.getTitleColor(),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
                                  languageData["Recent Transactions"] ?? "Recent Transactions",
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
                                  languageData["See All"] ?? "See All",
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
                        transactionController.transactionLists.isNotEmpty
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
                                                    text: languageData["Transaction ID"] ?? "Transaction ID",
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
                                                    text: languageData["Remarks"] ?? "Remarks",
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
                                                    text: languageData["Status"] ?? "Status",
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
                                        languageData["No Transactions Available"] ?? "No Transactions Available",
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
  }
}
