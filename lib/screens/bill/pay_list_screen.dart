import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/pay_list_controller.dart';
import 'package:bill_payment/screens/bill/bill_detail_screen.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:bill_payment/widgets/not_found.dart';
import 'package:bill_payment/widgets/shimmer_preloader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PayListScreen extends StatefulWidget {
  static const String routeName = "/payListScreen";
  const PayListScreen({super.key});

  @override
  State<PayListScreen> createState() => PayListScreenState();
}

class PayListScreenState extends State<PayListScreen> {
  final controller = Get.put(PayListController());
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
    Get.delete<PayListController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayListController>(
      builder: (controller) {
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
                controller.billPayLists.clear();
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
                                          languageData["Pay List"] ?? "Pay List",
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
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                backgroundColor: CustomColors.getContainerColor(),
                                                surfaceTintColor: Colors.transparent,
                                                content: Form(
                                                  key: controller.formKey,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        languageData["Filter List"] ?? "Filter List",
                                                        style: GoogleFonts.jost(
                                                          color: CustomColors.getTitleColor(),
                                                          fontSize: 20.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      TextFormField(
                                                        controller: controller.categoryController,
                                                        style: GoogleFonts.getFont(
                                                          'Jost',
                                                          textStyle: TextStyle(
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText: languageData["Category"] ?? "Category",
                                                          labelStyle: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                          ),
                                                          contentPadding: EdgeInsets.all(12.w),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide.none,
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide(
                                                              color: CustomColors.primaryColor,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          filled: true,
                                                          fillColor: CustomColors.getInputColor(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      TextFormField(
                                                        controller: controller.typeController,
                                                        style: GoogleFonts.getFont(
                                                          'Jost',
                                                          textStyle: TextStyle(
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText: languageData["Type"] ?? "Type",
                                                          labelStyle: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                          ),
                                                          contentPadding: EdgeInsets.all(12.w),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide.none,
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide(
                                                              color: CustomColors.primaryColor,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          filled: true,
                                                          fillColor: CustomColors.getInputColor(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      TextFormField(
                                                        controller: controller.dateController,
                                                        onTap: () async {
                                                          DateTime? selectedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(2000),
                                                            lastDate: DateTime(2101),
                                                          );

                                                          if (selectedDate != null) {
                                                            final formattedDate =
                                                                DateFormat('yyyy-MM-dd').format(selectedDate);
                                                            setState(() {
                                                              controller.dateController.text = formattedDate;
                                                            });
                                                          }
                                                        },
                                                        readOnly: true,
                                                        decoration: InputDecoration(
                                                          labelText: languageData["Select Date"] ?? "Select Date",
                                                          labelStyle: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                          ),
                                                          contentPadding: EdgeInsets.all(12.w),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide.none,
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide(
                                                              color: CustomColors.primaryColor,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          filled: true,
                                                          fillColor: CustomColors.getInputColor(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      DropdownButtonFormField2<String>(
                                                        isExpanded: true,
                                                        decoration: InputDecoration(
                                                          labelText: languageData["Select Type"] ?? "Select Type",
                                                          labelStyle: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                          ),
                                                          contentPadding: EdgeInsets.all(12.w),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide.none,
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            borderSide: BorderSide(
                                                              color: CustomColors.primaryColor,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          filled: true,
                                                          fillColor: CustomColors.getInputColor(),
                                                        ),
                                                        items: controller.statusTypes
                                                            .map((item) => DropdownMenuItem<String>(
                                                                  value: item,
                                                                  child: Text(
                                                                    item,
                                                                    style: GoogleFonts.jost(
                                                                      fontSize: 16.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: CustomColors.getTitleColor(),
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            controller.selectedStatusType = value;
                                                          });
                                                        },
                                                        buttonStyleData: ButtonStyleData(
                                                          padding: EdgeInsets.all(0.w),
                                                        ),
                                                        iconStyleData: IconStyleData(
                                                          icon: Icon(
                                                            CupertinoIcons.chevron_down,
                                                            color: CustomColors.getTextColor(),
                                                          ),
                                                          iconSize: 18,
                                                        ),
                                                        dropdownStyleData: DropdownStyleData(
                                                          maxHeight: 300,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(14.w),
                                                            color: CustomColors.getInputColor(),
                                                          ),
                                                          scrollbarTheme: ScrollbarThemeData(
                                                            radius: const Radius.circular(40),
                                                            thickness: MaterialStateProperty.all(3),
                                                            thumbVisibility: MaterialStateProperty.all(true),
                                                            thumbColor: const MaterialStatePropertyAll(
                                                                CustomColors.backgroundColor),
                                                          ),
                                                        ),
                                                        menuItemStyleData: MenuItemStyleData(
                                                          padding: EdgeInsets.only(left: 14.w, top: 8.h, bottom: 8.h),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      GestureDetector(
                                                        onTap: () {
                                                          controller.billPayLists = [];
                                                          controller.fetchData();
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                                                          width: 300.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: CustomColors.primaryColor,
                                                          ),
                                                          child: Text(
                                                            languageData["Filter"] ?? "Filter",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.jost(
                                                              color: CustomColors.whiteColor,
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.search,
                                          color: Colors.white,
                                          size: 28.sp,
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
                                : controller.billPayLists.isNotEmpty
                                    ? controller.isError
                                        ? NotFound(
                                            errorMessage: languageData["Error loading data. Please try again."] ??
                                                "Error loading data. Please try again.")
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: controller.billPayLists.length,
                                            itemBuilder: (context, index) {
                                              final item = controller.billPayLists[index];
                                              if (item.status.toLowerCase() == "completed") {
                                                controller.statusIcon = CupertinoIcons.check_mark_circled;
                                                controller.statusColor = CustomColors.primaryColor;
                                                controller.statusBgColor = CustomColors.primaryLight2;
                                              } else if (item.status.toLowerCase() == "pending" ||
                                                  item.status.toLowerCase() == "processing") {
                                                controller.statusIcon = Icons.restore_rounded;
                                                controller.statusColor = CustomColors.warningColor;
                                                controller.statusBgColor = CustomColors.warningLight;
                                              } else {
                                                controller.statusIcon = CupertinoIcons.return_icon;
                                                controller.statusColor = CustomColors.secondaryColor;
                                                controller.statusBgColor = CustomColors.secondaryLight;
                                              }
                                              return GestureDetector(
                                                onTap: () => Get.toNamed(BillDetailScreen.routeName,
                                                    arguments: item.id.toString()),
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
                                                    contentPadding:
                                                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
                                                      item.type,
                                                      maxLines: 1,
                                                      style: GoogleFonts.jost(
                                                        color: CustomColors.getTitleColor(),
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      item.category,
                                                      maxLines: 1,
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
                                                          "${item.date.substring(0, 11)}",
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
                                    : NotFound(errorMessage: languageData["No Data Available"] ?? "No Data Available"),
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
      },
    );
  }
}
