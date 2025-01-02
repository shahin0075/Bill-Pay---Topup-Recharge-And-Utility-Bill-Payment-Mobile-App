import 'package:bill_payment/controller/bill_detail_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BillDetailScreen extends StatefulWidget {
  static const String routeName = "/billDetailScreen";
  const BillDetailScreen({super.key});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  final controller = Get.put(BillDetailController());
  var id = Get.arguments as String;
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    controller.fetchData(id);
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillDetailController>(
      builder: (controller) {
        return Scaffold(
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
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.back,
                                      color: Colors.white,
                                      size: 28.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      languageData["Bill Details"] ?? "Bill Details",
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
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.settings,
                                      color: Colors.transparent,
                                      size: 24.sp,
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
                controller.billData != null
                    ? Container(
                        padding: EdgeInsets.only(top: 115.h),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 10.h),
                                width: double.infinity,
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
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageData["Transaction"] ?? "Transaction",
                                      style: GoogleFonts.jost(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: CustomColors.getTitleColor(),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Bill Method"] ?? "Bill Method",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.billMethod,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Payment Gateway"] ?? "Payment Gateway",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.paymentGateway ?? "",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Transaction Id"] ?? "Transaction Id",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.transactionId,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Status"] ?? "Status",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.status,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Exchange Rate"] ?? "Exchange Rate",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "1 ${controller.billData!.baseCurrency} = ${controller.billData!.exchangeRate.toString()}${controller.billData!.paymentCurrency}",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Pay In Base"] ?? "Pay In Base",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${controller.billData!.payInBase.toString()}${controller.billData!.baseCurrency}",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 10.h),
                                width: double.infinity,
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
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageData["Bill Information"] ?? "Bill Information",
                                      style: GoogleFonts.jost(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: CustomColors.getTitleColor(),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Category"] ?? "Category",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.category,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Type"] ?? "Type",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.type,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      padding: EdgeInsets.all(0.w),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.billData!.customers.length,
                                      itemBuilder: (context, index) {
                                        final item = controller.billData!.customers[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.all(0.w),
                                          dense: true,
                                          leading: Icon(
                                            CupertinoIcons.check_mark_circled,
                                            color: CustomColors.primaryColor,
                                          ),
                                          title: Text(
                                            item.fieldName,
                                            maxLines: 1,
                                            style: GoogleFonts.jost(
                                              color: CustomColors.getTitleColor(),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          trailing: Text(
                                            item.fieldValue,
                                            style: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Country Code"] ?? "Country Code",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        controller.billData!.countryCode,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Amount"] ?? "Amount",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${controller.billData!.amount.toString()} ${controller.billData!.paymentCurrency}",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Charge"] ?? "Charge",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${controller.billData!.charge.toString()} ${controller.billData!.paymentCurrency}",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      leading: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        languageData["Payable Amount"] ?? "Payable Amount",
                                        maxLines: 1,
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${controller.billData!.payableAmount.toString()} ${controller.billData!.paymentCurrency}",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTextColor(),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                          strokeWidth: 2.0,
                        ),
                      ),
              ],
            ));
      },
    );
  }
}
